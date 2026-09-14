--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local contextModule = require(script.Parent.Parent.state.context)
local elementModule = require(script.Parent.element)
local hooks = require(script.Parent.Parent.state.hooks)
local memoModule = require(script.Parent.memo)
local profiler = require(script.Parent.Parent.diagnostics.profiler)
local renderer = require(script.Parent.Parent.runtime.renderer)
local resourceModule = require(script.Parent.Parent.runtime.resource)

--————————————————————————————————————————————————————————————————————--

local module = {}
local internals: { [string]: any } = {}

--————————————————————————————————————————————————————————————————————--

--- Options controlling reconciliation and render requests.
--- @field forceRender boolean? Forces component reconciliation even when memoized inputs are unchanged.
--- @field renderReason string? Diagnostic reason recorded for the render.
--- @field requestRender (reason: string?) -> () Callback used to request another root render.
export type reconcileOptions = {
	forceRender: boolean?,
	renderReason: string?,
	requestRender: (reason: string?) -> (),
}

--- Runtime representation of a mounted Reactily element.
--- @field children {runtimeNode} Mounted child runtime nodes.
--- @field element element Current virtual element represented by the node.
--- @field errorValue any Most recent error captured by an error boundary.
--- @field hookContext componentContext? Hook state owned by component nodes.
--- @field host hostHandle? Mounted Roblox host handle.
--- @field isSuspended boolean Whether a Suspense node is currently showing its fallback.
--- @field parent Instance Current Roblox parent used for reconciliation.
--- @field suspenseCleanup (() -> ())? Cleanup for the active suspension subscription.
export type runtimeNode = {
	children: { runtimeNode },
	element: elementModule.element,
	errorValue: any,
	hookContext: hooks.componentContext?,
	host: renderer.hostHandle?,
	isSuspended: boolean,
	parent: Instance,
	suspenseCleanup: (() -> ())?,
}

--- Serializable diagnostic snapshot of a reconciled runtime node.
--- @field children {nodeSnapshot} Recursive child snapshots.
--- @field className string? Roblox class name for host nodes.
--- @field instance Instance? Mounted Roblox Instance for host nodes.
--- @field key string? Stable element key.
--- @field kind string Element kind.
--- @field suspended boolean? Whether the node is currently suspended.
export type nodeSnapshot = {
	children: { nodeSnapshot },
	className: string?,
	instance: Instance?,
	key: string?,
	kind: string,
	suspended: boolean?,
}

--————————————————————————————————————————————————————————————————————--

--- Returns the reconciliation key assigned to an element.
--- @param elementValue element Element whose key should be read.
--- @return string? Stable key when one is present.
local function getElementKey(elementValue: elementModule.element): string?
	return elementValue.key
end

--————————————————————————————————————————————————————————————————————--

--- Compares two child element arrays by identity and order.
--- @param first {element} First child array.
--- @param second {element} Second child array.
--- @return boolean Whether both arrays contain the same element references in the same order.
local function childrenEqual(first: { elementModule.element }, second: { elementModule.element }): boolean
	if first == second then
		return true
	end
	if #first ~= #second then
		return false
	end
	for index, child in first do
		if second[index] ~= child then
			return false
		end
	end
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Resolves the fallback element for an error boundary.
--- @param elementValue element Error-boundary element.
--- @param failure any Captured failure passed to a functional fallback.
--- @return element Resolved fallback element.
local function resolveFallback(elementValue: elementModule.element, failure: any): elementModule.element
	assert(elementValue.kind == "errorBoundary", "Reactily error fallback requires an error boundary.")
	if type(elementValue.fallback) == "function" then
		return (elementValue.fallback :: (failure: any) -> elementModule.element)(failure)
	end
	return elementValue.fallback
end

--————————————————————————————————————————————————————————————————————--

--- Disconnects the active suspension subscription owned by a runtime node.
--- @param node runtimeNode Runtime node whose suspension subscription should be released.
local function disconnectSuspense(node: runtimeNode)
	if not node.suspenseCleanup then
		return
	end
	node.suspenseCleanup()
	node.suspenseCleanup = nil
end

--————————————————————————————————————————————————————————————————————--

--- Subscribes a runtime node to a suspension and requests a render when it resolves.
--- @param node runtimeNode Runtime node entering the suspended state.
--- @param suspension suspension Suspension to observe.
--- @param options reconcileOptions Reconciliation callbacks used to request the follow-up render.
local function subscribeSuspense(node: runtimeNode, suspension: resourceModule.suspension, options: reconcileOptions)
	disconnectSuspense(node)
	local connected = true
	local cleanup: (() -> ())? = nil
	cleanup = suspension.subscribe(function()
		if not connected then
			return
		end
		connected = false
		if cleanup then
			cleanup()
		end
		node.suspenseCleanup = nil
		options.requestRender("suspense resolved")
	end)
	node.suspenseCleanup = function()
		if not connected then
			return
		end
		connected = false
		if cleanup then
			cleanup()
		end
	end
end

--————————————————————————————————————————————————————————————————————--

--- Runs a callback while a Reactily context value is temporarily provided.
--- @param contextValue any Context object to push.
--- @param providedValue any Value exposed while the callback runs.
--- @param callback () -> T Callback executed inside the provider scope.
--- @return T Callback result.
local function withContext<T>(contextValue: any, providedValue: any, callback: () -> T): T
	contextModule.push(contextValue, providedValue)
	local success, result = pcall(callback)
	contextModule.pop(contextValue)
	if success then
		return result :: T
	end
	error(result, 0)
end

--————————————————————————————————————————————————————————————————————--

--- Recursively deletes a runtime node and all resources owned by its subtree.
--- @param node runtimeNode Runtime node to delete.
function internals.deleteNode(node: runtimeNode)
	disconnectSuspense(node)
	for index = #node.children, 1, -1 do
		internals.deleteNode(node.children[index])
	end
	table.clear(node.children)
	if node.hookContext then
		hooks.deleteContext(node.hookContext)
		node.hookContext = nil
	end
	if node.host then
		renderer.deleteHost(node.host)
		node.host = nil
	end
	node.errorValue = nil
end

--————————————————————————————————————————————————————————————————————--

--- Mounts a virtual element into a new runtime node.
--- @param parent Instance Roblox parent used for mounted host instances.
--- @param elementValue element Virtual element to mount.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return runtimeNode Newly mounted runtime node.
function internals.mount(parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
	local node: runtimeNode = {
		children = {},
		element = elementValue,
		errorValue = nil,
		hookContext = nil,
		host = nil,
		isSuspended = false,
		parent = parent,
		suspenseCleanup = nil,
	}
	if elementValue.kind == "host" then
		local host = renderer.createHost(parent, elementValue)
		node.host = host
		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(host.instance, child, options)
		end
		return node
	end
	if elementValue.kind == "component" then
		local hookContext = hooks.newContext(options.requestRender)
		node.hookContext = hookContext
		local rendered = internals.renderComponent(elementValue, hookContext, options.renderReason or "mount")
		if rendered then
			node.children[1] = internals.mount(parent, rendered, options)
		end
		hooks.flushLayoutEffects(hookContext)
		hooks.flushEffects(hookContext)
		return node
	end
	if elementValue.kind == "portal" then
		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(elementValue.target, child, options)
		end
		return node
	end
	if elementValue.kind == "provider" then
		node.children = withContext(elementValue.contextValue, elementValue.providedValue, function(): { runtimeNode }
			local output: { runtimeNode } = {}
			for _, child in elementValue.children do
				output[#output + 1] = internals.mount(parent, child, options)
			end
			return output
		end)
		return node
	end
	if elementValue.kind == "errorBoundary" then
		local child = elementValue.children[1]
		local success, result = pcall(function(): runtimeNode
			return internals.mount(parent, child, options)
		end)
		local childOrFailure: any = result
		if success then
			node.children[1] = childOrFailure :: runtimeNode
			return node
		end
		if resourceModule.isSuspension(childOrFailure) then
			error(childOrFailure, 0)
		end
		node.errorValue = childOrFailure
		if elementValue.onError then
			elementValue.onError(childOrFailure)
		end
		node.children[1] = internals.mount(parent, resolveFallback(elementValue, childOrFailure), options)
		return node
	end
	if elementValue.kind == "suspense" then
		local child = elementValue.children[1]
		local success, result = pcall(function(): runtimeNode
			return internals.mount(parent, child, options)
		end)
		local childOrFailure: any = result
		if success then
			node.children[1] = childOrFailure :: runtimeNode
			return node
		end
		if not resourceModule.isSuspension(childOrFailure) then
			error(childOrFailure, 0)
		end
		local suspension: resourceModule.suspension = childOrFailure
		node.isSuspended = true
		subscribeSuspense(node, suspension, options)
		node.children[1] = internals.mount(parent, elementValue.fallback, options)
		return node
	end
	for _, child in elementValue.children do
		node.children[#node.children + 1] = internals.mount(parent, child, options)
	end
	return node
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles one virtual element against an existing runtime node.
--- @param parent Instance Roblox parent for the reconciled subtree.
--- @param currentNode runtimeNode? Existing runtime node.
--- @param nextElement element? Desired next element.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return runtimeNode? Reused, replaced, mounted, or removed runtime node.
function internals.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	if not currentNode and not nextElement then
		return nil
	end
	if not currentNode then
		assert(nextElement, "Reactily reconcile requires a next element when mounting.")
		return internals.mount(parent, nextElement, options)
	end
	if not nextElement then
		internals.deleteNode(currentNode)
		return nil
	end
	if not internals.sameIdentity(currentNode.element, nextElement) then
		internals.deleteNode(currentNode)
		return internals.mount(parent, nextElement, options)
	end
	local previousElement = currentNode.element
	currentNode.element = nextElement
	currentNode.parent = parent
	if nextElement.kind == "host" then
		local host = currentNode.host
		assert(host, "Reactily host runtime node is missing its host handle.")
		assert(previousElement.kind == "host", "Reactily host identity changed unexpectedly.")
		if host.instance.Parent ~= parent then
			host.instance.Parent = parent
		end
		renderer.updateHost(host, previousElement.props, nextElement.props)
		currentNode.children =
			internals.reconcileChildren(host.instance, currentNode.children, nextElement.children, options)
		return currentNode
	end
	if nextElement.kind == "component" then
		local hookContext = currentNode.hookContext
		assert(hookContext, "Reactily component runtime node is missing hook context.")
		assert(previousElement.kind == "component", "Reactily component identity changed unexpectedly.")
		local propsChanged = memoModule.shouldUpdate(nextElement.component, previousElement.props, nextElement.props)
		local childInputsChanged = not childrenEqual(previousElement.children, nextElement.children)
		if
			memoModule.isMemo(nextElement.component)
			and not options.forceRender
			and not hookContext.needsRender
			and not propsChanged
			and not childInputsChanged
		then
			return currentNode
		end
		local reason = options.renderReason or "parent rendered"
		if propsChanged or childInputsChanged then
			reason = "props changed"
		end
		if not propsChanged and not childInputsChanged and hookContext.needsRender then
			reason = "component state changed"
		end
		local rendered = internals.renderComponent(nextElement, hookContext, reason)
		local currentChild = currentNode.children[1]
		local nextChild = internals.reconcile(parent, currentChild, rendered, options)
		table.clear(currentNode.children)
		if nextChild then
			currentNode.children[1] = nextChild
		end
		hooks.flushLayoutEffects(hookContext)
		hooks.flushEffects(hookContext)
		return currentNode
	end
	if nextElement.kind == "portal" then
		currentNode.children =
			internals.reconcileChildren(nextElement.target, currentNode.children, nextElement.children, options)
		return currentNode
	end
	if nextElement.kind == "provider" then
		assert(previousElement.kind == "provider", "Reactily context-provider identity changed unexpectedly.")
		local childOptions = options
		if previousElement.providedValue ~= nextElement.providedValue then
			childOptions = table.clone(options)
			childOptions.forceRender = true
			childOptions.renderReason = "context changed"
		end
		currentNode.children = withContext(
			nextElement.contextValue,
			nextElement.providedValue,
			function(): { runtimeNode }
				return internals.reconcileChildren(parent, currentNode.children, nextElement.children, childOptions)
			end
		)
		return currentNode
	end
	if nextElement.kind == "errorBoundary" then
		assert(previousElement.kind == "errorBoundary", "Reactily error-boundary identity changed unexpectedly.")
		local child = nextElement.children[1]
		local success, result = pcall(function(): runtimeNode?
			local currentChild: runtimeNode? = currentNode.children[1]
			if currentNode.errorValue ~= nil then
				currentChild = nil
			end
			return internals.reconcile(parent, currentChild, child, options)
		end)
		local childOrFailure: any = result
		if success then
			if currentNode.errorValue then
				for _, currentChild in currentNode.children do
					internals.deleteNode(currentChild)
				end
			end
			currentNode.errorValue = nil
			table.clear(currentNode.children)
			if childOrFailure then
				currentNode.children[1] = childOrFailure :: runtimeNode
			end
			return currentNode
		end
		if resourceModule.isSuspension(childOrFailure) then
			error(childOrFailure, 0)
		end
		for _, currentChild in currentNode.children do
			internals.deleteNode(currentChild)
		end
		table.clear(currentNode.children)
		currentNode.errorValue = childOrFailure
		if nextElement.onError then
			nextElement.onError(childOrFailure)
		end
		currentNode.children[1] = internals.mount(parent, resolveFallback(nextElement, childOrFailure), options)
		return currentNode
	end
	if nextElement.kind == "suspense" then
		assert(previousElement.kind == "suspense", "Reactily Suspense identity changed unexpectedly.")
		local child = nextElement.children[1]
		local existing: runtimeNode? = currentNode.children[1]
		if currentNode.isSuspended and existing then
			internals.deleteNode(existing)
			table.clear(currentNode.children)
			existing = nil
		end
		local success, result = pcall(function(): runtimeNode?
			return internals.reconcile(parent, existing, child, options)
		end)
		local childOrFailure: any = result
		if success then
			disconnectSuspense(currentNode)
			currentNode.isSuspended = false
			table.clear(currentNode.children)
			if childOrFailure then
				currentNode.children[1] = childOrFailure :: runtimeNode
			end
			return currentNode
		end
		if not resourceModule.isSuspension(childOrFailure) then
			error(childOrFailure, 0)
		end
		if existing then
			internals.deleteNode(existing)
		end
		table.clear(currentNode.children)
		local suspension: resourceModule.suspension = childOrFailure
		currentNode.isSuspended = true
		subscribeSuspense(currentNode, suspension, options)
		currentNode.children[1] = internals.mount(parent, nextElement.fallback, options)
		return currentNode
	end
	currentNode.children = internals.reconcileChildren(parent, currentNode.children, nextElement.children, options)
	return currentNode
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles a child list while preserving keyed identity and positional unkeyed identity.
--- @param parent Instance Roblox parent for the child subtree.
--- @param currentChildren {runtimeNode} Existing runtime children.
--- @param nextChildren {element} Desired child elements.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return {runtimeNode} Reconciled child runtime nodes.
function internals.reconcileChildren(
	parent: Instance,
	currentChildren: { runtimeNode },
	nextChildren: { elementModule.element },
	options: reconcileOptions
): { runtimeNode }
	local currentByKey: { [string]: runtimeNode } = {}
	local currentWithoutKey: { runtimeNode } = {}
	local nextKeys: { [string]: boolean } = {}
	local output: { runtimeNode } = table.create(#nextChildren)
	local usedNodes: { [runtimeNode]: boolean } = {}
	for _, currentNode in currentChildren do
		local key = getElementKey(currentNode.element)
		if not key then
			currentWithoutKey[#currentWithoutKey + 1] = currentNode
			continue
		end
		assert(not currentByKey[key], `Reactily current children contain duplicate key "{key}".`)
		currentByKey[key] = currentNode
	end
	local unkeyedIndex = 0
	for _, nextElement in nextChildren do
		local key = getElementKey(nextElement)
		local currentNode: runtimeNode? = nil
		if key then
			assert(not nextKeys[key], `Reactily next children contain duplicate key "{key}".`)
			nextKeys[key] = true
			currentNode = currentByKey[key]
		end
		if not key then
			unkeyedIndex += 1
			currentNode = currentWithoutKey[unkeyedIndex]
		end
		if currentNode then
			usedNodes[currentNode] = true
		end
		local nextNode = internals.reconcile(parent, currentNode, nextElement, options)
		if not nextNode then
			continue
		end
		output[#output + 1] = nextNode
	end
	for _, currentNode in currentChildren do
		if usedNodes[currentNode] then
			continue
		end
		internals.deleteNode(currentNode)
	end
	table.clear(currentByKey)
	table.clear(currentChildren)
	table.clear(currentWithoutKey)
	table.clear(nextKeys)
	table.clear(usedNodes)
	return output
end

--————————————————————————————————————————————————————————————————————--

--- Renders a component while managing hook context and profiler diagnostics.
--- @param elementValue element Component element to render.
--- @param context componentContext Hook context owned by the component.
--- @param reason string Diagnostic reason for the render.
--- @return element? Element returned by the component.
function internals.renderComponent(
	elementValue: elementModule.element,
	context: hooks.componentContext,
	reason: string
): elementModule.element?
	assert(elementValue.kind == "component", "Reactily component renderer requires a component element.")
	local props = table.clone(elementValue.props)
	props.children = elementValue.children
	hooks.beginRender(context)
	local started = os.clock()
	local success, result = pcall(elementValue.component, props)
	local duration = os.clock() - started
	hooks.endRender(context, success)
	profiler.record(elementValue.component, duration, reason)
	if not success then
		error(result, 0)
	end
	return result
end

--————————————————————————————————————————————————————————————————————--

--- Determines whether two elements can reuse the same runtime node.
--- @param current element Currently mounted element.
--- @param nextValue element Desired next element.
--- @return boolean Whether reconciliation may preserve the existing runtime identity.
function internals.sameIdentity(current: elementModule.element, nextValue: elementModule.element): boolean
	if current.kind ~= nextValue.kind then
		return false
	end
	if current.key ~= nextValue.key then
		return false
	end
	if current.kind == "host" and nextValue.kind == "host" then
		return current.className == nextValue.className
	end
	if current.kind == "component" and nextValue.kind == "component" then
		return current.component == nextValue.component
	end
	if current.kind == "provider" and nextValue.kind == "provider" then
		return current.contextValue == nextValue.contextValue
	end
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a reconciled runtime tree.
--- @param node runtimeNode? Root runtime node.
--- @return boolean True when a node was deleted.
function module.delete(node: runtimeNode?): boolean
	if not node then
		return false
	end
	internals.deleteNode(node)
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Returns a recursive diagnostic snapshot of a runtime tree.
--- @param node runtimeNode? Root runtime node.
--- @return nodeSnapshot? Snapshot suitable for development tooling.
function module.inspect(node: runtimeNode?): nodeSnapshot?
	if not node then
		return nil
	end
	local snapshot: nodeSnapshot = {
		children = {},
		key = node.element.key,
		kind = node.element.kind,
		suspended = node.isSuspended,
	}
	if node.element.kind == "host" then
		snapshot.className = node.element.className
		if node.host then
			snapshot.instance = node.host.instance
		end
	end
	for _, child in node.children do
		local childSnapshot = module.inspect(child)
		if childSnapshot then
			snapshot.children[#snapshot.children + 1] = childSnapshot
		end
	end
	return snapshot
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles one virtual element against an existing runtime node.
--- @param parent Instance Host parent.
--- @param currentNode runtimeNode? Existing runtime node.
--- @param nextElement element? Desired virtual element.
--- @param options reconcileOptions Reconciliation callbacks and diagnostics.
--- @return runtimeNode? Updated runtime node.
function module.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	return internals.reconcile(parent, currentNode, nextElement, options)
end

--————————————————————————————————————————————————————————————————————--

return module
