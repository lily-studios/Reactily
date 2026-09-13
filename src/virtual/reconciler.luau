--!strict

-- reconciles Reactily elements with mounted runtime nodes

--————————————————————————————————————————————————————————————————————--

local module = {}

local internals = {}

--————————————————————————————————————————————————————————————————————--

local runtime = script.Parent.Parent:WaitForChild("runtime")
local state = script.Parent.Parent:WaitForChild("state")

local elementModule = require(script.Parent:WaitForChild("element"))
local hooks = require(state:WaitForChild("hooks"))
local renderer = require(runtime:WaitForChild("renderer"))

--————————————————————————————————————————————————————————————————————--

export type reconcileOptions = {
	requestRender: () -> (),
}

export type runtimeNode = {
	children: {runtimeNode},
	element: elementModule.element,
	hookContext: hooks.componentContext?,
	host: renderer.hostHandle?,
	parent: Instance,
}

--————————————————————————————————————————————————————————————————————--

local function getElementKey(elementValue: elementModule.element): string?
	return elementValue.key
end

--————————————————————————————————————————————————————————————————————--

--- Recursively deletes a runtime node and all resources owned by its descendants.
--- @param node runtimeNode Runtime node to delete.
function internals.deleteNode(node: runtimeNode)
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
end

--————————————————————————————————————————————————————————————————————--

--- Mounts a new element and recursively creates its runtime node tree.
--- @param parent Instance Roblox parent used for mounted host elements.
--- @param elementValue elementModule.element Element to mount.
--- @param options reconcileOptions Reconciliation callbacks and options.
--- @return runtimeNode Newly mounted runtime node.
function internals.mount(
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	local node: runtimeNode = {
		children = {},
		element = elementValue,
		hookContext = nil,
		host = nil,
		parent = parent,
	}

	if elementValue.kind == "host" then
		local host = renderer.createHost(parent, elementValue)

		node.host = host

		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(
				host.instance,
				child,
				options
			)
		end

		return node
	end

	if elementValue.kind == "component" then
		local hookContext = hooks.newContext(options.requestRender)

		node.hookContext = hookContext

		local rendered = internals.renderComponent(elementValue, hookContext)

		if rendered then
			node.children[1] = internals.mount(parent, rendered, options)
		end

		hooks.flushEffects(hookContext)

		return node
	end

	if elementValue.kind == "portal" then
		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(
				elementValue.target,
				child,
				options
			)
		end

		return node
	end

	for _, child in elementValue.children do
		node.children[#node.children + 1] = internals.mount(
			parent,
			child,
			options
		)
	end

	return node
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles an existing runtime node against the next element.
--- Nodes with incompatible identity are deleted and remounted.
--- @param parent Instance Roblox parent used for mounted hosts.
--- @param currentNode runtimeNode? Currently mounted runtime node.
--- @param nextElement elementModule.element? Element requested for the next render.
--- @param options reconcileOptions Reconciliation callbacks and options.
--- @return runtimeNode? Updated runtime node, or nil when the element is unmounted.
function internals.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	if not currentNode and not nextElement then return nil end

	if not currentNode then
		assert(
			nextElement,
			"[Reactily] Reconcile requires a next element when no current node exists."
		)

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

		assert(host, "[Reactily] Host runtime node is missing its host handle.")
		assert(
			previousElement.kind == "host",
			"[Reactily] Host identity changed unexpectedly."
		)

		renderer.updateHost(
			host,
			previousElement.props,
			nextElement.props
		)

		currentNode.children = internals.reconcileChildren(
			host.instance,
			currentNode.children,
			nextElement.children,
			options
		)

		return currentNode
	end

	if nextElement.kind == "component" then
		local hookContext = currentNode.hookContext

		assert(
			hookContext,
			"Reactily component runtime node is missing hook context."
		)

		local rendered = internals.renderComponent(
			nextElement,
			hookContext
		)

		local currentChild = currentNode.children[1]
		local nextChild = internals.reconcile(
			parent,
			currentChild,
			rendered,
			options
		)

		table.clear(currentNode.children)

		if nextChild then
			currentNode.children[1] = nextChild
		end

		hooks.flushEffects(hookContext)

		return currentNode
	end

	if nextElement.kind == "portal" then
		currentNode.children = internals.reconcileChildren(
			nextElement.target,
			currentNode.children,
			nextElement.children,
			options
		)

		return currentNode
	end

	currentNode.children = internals.reconcileChildren(
		parent,
		currentNode.children,
		nextElement.children,
		options
	)

	return currentNode
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles an ordered child collection using keys when available.
--- Keyed children preserve identity across movement while unkeyed children match by position.
--- @param parent Instance Roblox parent used for mounted child hosts.
--- @param currentChildren {runtimeNode} Currently mounted child nodes.
--- @param nextChildren {elementModule.element} Child elements requested for the next render.
--- @param options reconcileOptions Reconciliation callbacks and options.
--- @return {runtimeNode} Reconciled child runtime nodes in next-element order.
function internals.reconcileChildren(
	parent: Instance,
	currentChildren: {runtimeNode},
	nextChildren: {elementModule.element},
	options: reconcileOptions
): {runtimeNode}
	local currentByKey: {[string]: runtimeNode} = {}
	local currentWithoutKey: {runtimeNode} = {}
	local nextKeys: {[string]: boolean} = {}
	local output: {runtimeNode} = table.create(#nextChildren)
	local usedNodes: {[runtimeNode]: boolean} = {}

	for _, currentNode in currentChildren do
		local key = getElementKey(currentNode.element)

		if not key then
			currentWithoutKey[#currentWithoutKey + 1] = currentNode

			continue
		end

		assert(
			not currentByKey[key],
			`Reactily current children contain duplicate key "{key}".`
		)

		currentByKey[key] = currentNode
	end

	local unkeyedIndex = 0

	for _, nextElement in nextChildren do
		local key = getElementKey(nextElement)
		local currentNode: runtimeNode? = nil

		if key then
			assert(
				not nextKeys[key],
				`Reactily next children contain duplicate key "{key}".`
			)

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

		local nextNode = internals.reconcile(
			parent,
			currentNode,
			nextElement,
			options
		)

		if not nextNode then continue end

		output[#output + 1] = nextNode
	end

	for _, currentNode in currentChildren do
		if usedNodes[currentNode] then continue end

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

--- Renders a function component within its hook context.
--- Component children are exposed through props.children during rendering.
--- @param elementValue elementModule.element Component element to render.
--- @param context hooks.componentContext Hook context owned by the component node.
--- @return elementModule.element? Element returned by the component, or nil when it renders nothing.
function internals.renderComponent(
	elementValue: elementModule.element,
	context: hooks.componentContext
): elementModule.element?
	assert(
		elementValue.kind == "component",
		"Reactily component renderer requires a component element."
	)

	local props = table.clone(elementValue.props)

	props.children = elementValue.children

	hooks.beginRender(context)

	local success, result = pcall(elementValue.component, props)

	hooks.endRender(context, success)

	if not success then
		error(result)
	end

	return result
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether two elements may reuse the same runtime node.
--- Identity includes element kind, key, and kind-specific host/component/portal identity.
--- @param current elementModule.element Currently mounted element.
--- @param nextValue elementModule.element Element requested for the next render.
--- @return boolean Whether the existing runtime node can be reused.
function internals.sameIdentity(
	current: elementModule.element,
	nextValue: elementModule.element
): boolean
	if current.kind ~= nextValue.kind then return false end
	if current.key ~= nextValue.key then return false end

	if current.kind == "host" and nextValue.kind == "host" then
		return current.className == nextValue.className
	end

	if current.kind == "component" and nextValue.kind == "component" then
		return current.component == nextValue.component
	end

	if current.kind == "portal" and nextValue.kind == "portal" then
		return current.target == nextValue.target
	end

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a runtime tree when one is mounted.
--- @param node runtimeNode? Root runtime node to delete.
--- @return boolean Whether a runtime node existed and was deleted.
function module.delete(node: runtimeNode?): boolean
	if not node then return false end

	internals.deleteNode(node)

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles a mounted runtime tree against the requested Reactily element.
--- Supplying nil as nextElement unmounts the current runtime tree.
--- @param parent Instance Roblox parent used for mounted hosts.
--- @param currentNode runtimeNode? Currently mounted runtime tree.
--- @param nextElement elementModule.element? Element requested for the next render.
--- @param options reconcileOptions Reconciliation callbacks and options.
--- @return runtimeNode? Reconciled runtime tree, or nil when unmounted.
function module.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	return internals.reconcile(
		parent,
		currentNode,
		nextElement,
		options
	)
end

--————————————————————————————————————————————————————————————————————--

return module