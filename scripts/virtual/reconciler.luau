--[[
   Reactily · Lily Studios
   Copyright (c) Lily Studios and contributors.
   Licensed under the MIT License.
   See LICENSE in the repository root for full terms.
]]
--!strict

--————————————————————————————————————————————————————————————————————--
local activityModule = require(script.Parent.Parent.runtime.activity)
local contextModule = require(script.Parent.Parent.state.context)
local elementModule = require(script.Parent.element)
local fragmentRefModule = require(script.Parent.Parent.runtime.fragmentRef)
local hooks = require(script.Parent.Parent.state.hooks)
local memoModule = require(script.Parent.memo)
local profiler = require(script.Parent.Parent.diagnostics.profiler)
local renderer = require(script.Parent.Parent.runtime.renderer)
local resourceModule = require(script.Parent.Parent.runtime.resource)
local strictModeModule = require(script.Parent.Parent.diagnostics.strictMode)
local viewTransitionModule = require(script.Parent.Parent.runtime.viewTransition)

--————————————————————————————————————————————————————————————————————--
local module = {}
local internals: { [string]: any } = {}

--————————————————————————————————————————————————————————————————————--

--- Options controlling reconciliation and render requests.
--- @field forceRender boolean? Forces component reconciliation even when memoized inputs are unchanged.
--- @field renderReason string? Diagnostic reason recorded for the render.
--- @field requestRender (reason: string?) -> () Callback used to request another root render.
export type reconcileOptions = {
	ForceRender: boolean?,
	HiddenActivity: boolean?,
	RenderReason: string?,
	RequestRender: (reason: string?) -> (),
	StrictMode: boolean?,
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
	Children: { runtimeNode },
	Element: elementModule.element,
	ErrorValue: any,
	FragmentHandle: fragmentRefModule.fragmentInstance?,
	FragmentRefTarget: fragmentRefModule.refTarget?,
	HookContext: hooks.componentContext?,
	Host: renderer.hostHandle?,
	IsSuspended: boolean,
	Parent: Instance,
	SuspenseCleanup: (() -> ())?,
	ViewTweens: { Tween }?,
}

--- Serializable diagnostic snapshot of a reconciled runtime node.
--- @field children {nodeSnapshot} Recursive child snapshots.
--- @field className string? Roblox class name for host nodes.
--- @field instance Instance? Mounted Roblox Instance for host nodes.
--- @field key string? Stable element key.
--- @field kind string Element kind.
--- @field suspended boolean? Whether the node is currently suspended.
export type nodeSnapshot = {
	Children: { nodeSnapshot },
	ClassName: string?,
	Instance: Instance?,
	Key: string?,
	Kind: string,
	Suspended: boolean?,
}

--————————————————————————————————————————————————————————————————————--

--- Returns the reconciliation key assigned to an element.
--- @param elementValue element Element whose key should be read.
--- @return string? Stable key when one is present.
local function getElementKey(elementValue: elementModule.element): string?
	return elementValue.Key
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
	assert(elementValue.Kind == "errorBoundary", "Reactily error fallback requires an error boundary.")
	if type(elementValue.Fallback) == "function" then
		return (elementValue.Fallback :: (failure: any) -> elementModule.element)(failure)
	end
	return elementValue.Fallback
end

--————————————————————————————————————————————————————————————————————--

--- Disconnects the active suspension subscription owned by a runtime node.
--- @param node runtimeNode Runtime node whose suspension subscription should be released.
local function disconnectSuspense(node: runtimeNode)
	if not node.SuspenseCleanup then
		return
	end
	node.SuspenseCleanup()
	node.SuspenseCleanup = nil
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
	cleanup = suspension.Subscribe(function()
		if not connected then
			return
		end
		connected = false
		if cleanup then
			cleanup()
		end
		node.SuspenseCleanup = nil
		options.RequestRender("suspense resolved")
	end)
	node.SuspenseCleanup = function()
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
	contextModule.Push(contextValue, providedValue)
	local success, result = pcall(callback)
	contextModule.Pop(contextValue)
	if success then
		return result :: T
	end
	error(result, 0)
end

--————————————————————————————————————————————————————————————————————--
--- Recursively collects Roblox host instances from a mounted subtree.
--- @param node runtimeNode Root runtime node to traverse.
--- @param output {Instance} Mutable array receiving every discovered host instance.
local function collectAllHostInstances(node: runtimeNode, output: { Instance })
	if node.Host then
		output[#output + 1] = node.Host.Instance
	end
	for _, child in node.Children do
		collectAllHostInstances(child, output)
	end
end
--- Collects the first host instance along each branch of a runtime node list.
--- @param nodes {runtimeNode} Runtime nodes to inspect.
--- @return {Instance} First-level host instances in traversal order.
local function collectFirstLevelHostInstances(nodes: { runtimeNode }): { Instance }
	local output: { Instance } = {}
	--- Visits a subtree, stopping descent whenever a host instance is found.
	--- @param node runtimeNode Runtime node to inspect.
	local function visit(node: runtimeNode)
		if node.Host then
			output[#output + 1] = node.Host.Instance
			return
		end
		for _, child in node.Children do
			visit(child)
		end
	end
	for _, node in nodes do
		visit(node)
	end
	return output
end
--- Returns every host instance contained in a runtime subtree.
--- @param node runtimeNode Subtree root.
--- @return {Instance} Host instances found in the subtree.
local function collectNodeInstances(node: runtimeNode): { Instance }
	local output: { Instance } = {}
	collectAllHostInstances(node, output)
	return output
end
--- Replays host refs recursively for strict-mode validation.
--- @param node runtimeNode Subtree containing refs to replay.
local function replayHostRefs(node: runtimeNode)
	if node.Host then
		renderer.ReplayRef(node.Host)
	end
	for _, child in node.Children do
		replayHostRefs(child)
	end
end
--- Updates host visibility and effect execution for an Activity subtree.
--- @param node runtimeNode Subtree whose visibility is being updated.
--- @param hidden boolean Whether the Activity subtree should be hidden.
--- @param isBoundaryRoot boolean? Whether this node is the boundary being toggled.
local function setActivityHidden(node: runtimeNode, hidden: boolean, isBoundaryRoot: boolean?)
	-- When revealing an outer Activity, preserve any nested Activity that is
	-- independently hidden.
	if not hidden and not isBoundaryRoot and node.Element.Kind == "activity" and node.Element.Mode == "hidden" then
		return
	end
	if node.Host then
		if hidden then
			activityModule.Hide(node.Host.Instance)
		else
			activityModule.Show(node.Host.Instance)
		end
	end
	if node.HookContext then
		if hidden then
			hooks.PauseEffects(node.HookContext)
		else
			hooks.ResumeEffects(node.HookContext)
		end
	end
	for _, child in node.Children do
		setActivityHidden(child, hidden, false)
	end
end
--- Updates a fragment ref and refreshes its mounted-instance view.
--- @param node runtimeNode Fragment runtime node that owns the ref handle.
--- @param target refTarget? Desired ref target, or nil to detach the old ref.
local function syncFragmentRef(node: runtimeNode, target: fragmentRefModule.refTarget?)
	if node.FragmentRefTarget == target and node.FragmentHandle then
		node.FragmentHandle.Refresh()
		return
	end
	if node.FragmentRefTarget then
		fragmentRefModule.Assign(node.FragmentRefTarget, nil)
	end
	if not node.FragmentHandle then
		node.FragmentHandle = fragmentRefModule.New(function(): { Instance }
			return collectFirstLevelHostInstances(node.Children)
		end)
	end
	node.FragmentRefTarget = target
	if target then
		fragmentRefModule.Assign(target, node.FragmentHandle)
	end
end
--- Flushes component effects or pauses them for a hidden Activity.
--- @param context componentContext Component hook state that owns the effects.
--- @param options reconcileOptions Render options including Activity and StrictMode state.
--- @param replayStrict boolean Whether StrictMode should replay effects on this flush.
local function flushComponentEffects(context: hooks.componentContext, options: reconcileOptions, replayStrict: boolean)
	if options.HiddenActivity then
		hooks.PauseEffects(context)
		return
	end
	hooks.FlushInsertionEffects(context)
	hooks.FlushLayoutEffects(context)
	hooks.FlushEffects(context)
	if replayStrict and options.StrictMode and strictModeModule.IsEnabled() then
		hooks.ReplayEffects(context)
	end
end

--————————————————————————————————————————————————————————————————————--

--- Invokes an optional view-transition lifecycle callback without changing its return contract.
--- @param callback (() -> ())? Optional zero-return lifecycle callback.
--- @param stage string Lifecycle stage used for diagnostic warnings.
local function runViewTransitionCallback(callback: (() -> ())?, stage: string)
	if not callback then
		return
	end

	local success, failure = pcall(function(): boolean
		callback()
		return true
	end)

	if not success then
		warn(`Reactily ViewTransition {stage} failed: {failure}`)
	end
end

--- Recursively deletes a runtime node and all resources owned by its subtree.
--- @param node runtimeNode Runtime node to delete.
function internals.DeleteNode(node: runtimeNode)
	disconnectSuspense(node)
	if node.Element.Kind == "viewTransition" then
		runViewTransitionCallback(node.Element.OnExit, "onExit")
		if node.ViewTweens then
			viewTransitionModule.Cancel(node.ViewTweens)
			node.ViewTweens = nil
		end
	end
	if node.FragmentRefTarget then
		fragmentRefModule.Assign(node.FragmentRefTarget, nil)
		node.FragmentRefTarget = nil
	end
	if node.FragmentHandle then
		node.FragmentHandle.Delete()
		node.FragmentHandle = nil
	end
	for index = #node.Children, 1, -1 do
		internals.DeleteNode(node.Children[index])
	end
	table.clear(node.Children)
	if node.HookContext then
		hooks.DeleteContext(node.HookContext)
		node.HookContext = nil
	end
	if node.Host then
		renderer.DeleteHost(node.Host)
		node.Host = nil
	end
	node.ErrorValue = nil
end

--————————————————————————————————————————————————————————————————————--

--- Mounts a host element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the host element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Host element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountHostNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "host", "Reactily host mount requires the matching element kind.")
	local host = renderer.CreateHost(parent, elementValue)
	node.Host = host
	for _, child in elementValue.Children do
		node.Children[#node.Children + 1] = internals.mount(host.Instance, child, options)
	end
	return node
end

--- Mounts a component element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the component element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Component element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountComponentNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "component", "Reactily component mount requires the matching element kind.")
	local hookContext = hooks.NewContext(options.RequestRender)
	node.HookContext = hookContext
	local rendered =
		internals.RenderComponent(elementValue, hookContext, options.RenderReason or "mount", options.StrictMode == true)
	if rendered then
		node.Children[1] = internals.mount(parent, rendered, options)
	end
	flushComponentEffects(hookContext, options, true)
	return node
end

--- Mounts a portal element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the portal element.
--- @param _parent Instance Unused parent argument; portal descendants mount into the portal target.
--- @param elementValue element Portal element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountPortalNode(
	node: runtimeNode,
	_parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "portal", "Reactily portal mount requires the matching element kind.")
	for _, child in elementValue.Children do
		node.Children[#node.Children + 1] = internals.mount(elementValue.target, child, options)
	end
	return node
end

--- Mounts a provider element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the provider element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Provider element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountProviderNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "provider", "Reactily provider mount requires the matching element kind.")
	node.Children = withContext(elementValue.ContextValue, elementValue.ProvidedValue, function(): { runtimeNode }
		local output: { runtimeNode } = {}
		for _, child in elementValue.Children do
			output[#output + 1] = internals.mount(parent, child, options)
		end
		return output
	end)
	return node
end

--- Mounts a errorBoundary element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the error boundary element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Error boundary element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountErrorBoundaryNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "errorBoundary", "Reactily errorBoundary mount requires the matching element kind.")
	local child = elementValue.Children[1]
	local childSuccess, childResult = pcall(function(): runtimeNode
		return internals.mount(parent, child, options)
	end)
	local childOrFailure: any = childResult
	if childSuccess then
		node.Children[1] = childOrFailure :: runtimeNode
		return node
	end
	if resourceModule.IsSuspension(childOrFailure) then
		error(childOrFailure, 0)
	end
	node.ErrorValue = childOrFailure
	if elementValue.OnError then
		elementValue.OnError(childOrFailure)
	end
	node.Children[1] = internals.mount(parent, resolveFallback(elementValue, childOrFailure), options)
	return node
end

--- Mounts a suspense element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the Suspense element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Suspense element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountSuspenseNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "suspense", "Reactily suspense mount requires the matching element kind.")
	local child = elementValue.Children[1]
	local suspenseSuccess, suspenseResult = pcall(function(): runtimeNode
		return internals.mount(parent, child, options)
	end)
	local childOrFailure: any = suspenseResult
	if suspenseSuccess then
		node.Children[1] = childOrFailure :: runtimeNode
		return node
	end
	if not resourceModule.IsSuspension(childOrFailure) then
		error(childOrFailure, 0)
	end
	local suspension: resourceModule.suspension = childOrFailure
	node.IsSuspended = true
	subscribeSuspense(node, suspension, options)
	node.Children[1] = internals.mount(parent, elementValue.Fallback, options)
	return node
end

--- Mounts a activity element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the Activity element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Activity element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountActivityNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "activity", "Reactily activity mount requires the matching element kind.")
	local childOptions = table.clone(options)
	childOptions.HiddenActivity = options.HiddenActivity == true or elementValue.Mode == "hidden"
	for _, child in elementValue.Children do
		node.Children[#node.Children + 1] = internals.mount(parent, child, childOptions)
	end
	if childOptions.HiddenActivity then
		setActivityHidden(node, true, true)
	end
	return node
end

--- Mounts a profiler element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the Profiler element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Profiler element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountProfilerNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "profiler", "Reactily profiler mount requires the matching element kind.")
	local child = elementValue.Children[1]
	local started = os.clock()
	node.Children[1] = internals.mount(parent, child, options)
	local duration = os.clock() - started
	if elementValue.OnRender then
		elementValue.OnRender(elementValue.Id, "mount", duration, options.RenderReason or "mount")
	end
	return node
end

--- Mounts a strictMode element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the StrictMode element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Strictmode element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountStrictModeNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "strictMode", "Reactily strictMode mount requires the matching element kind.")
	local childOptions = table.clone(options)
	childOptions.StrictMode = true
	for _, child in elementValue.Children do
		node.Children[#node.Children + 1] = internals.mount(parent, child, childOptions)
	end
	if strictModeModule.IsEnabled() then
		for _, childNode in node.Children do
			replayHostRefs(childNode)
		end
	end
	return node
end

--- Mounts a viewTransition element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the ViewTransition element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Viewtransition element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountViewTransitionNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "viewTransition", "Reactily viewTransition mount requires the matching element kind.")
	local child = elementValue.Children[1]
	node.Children[1] = internals.mount(parent, child, options)
	local instances = collectNodeInstances(node)
	node.ViewTweens = viewTransitionModule.PlayEnter(instances, elementValue.Config)
	runViewTransitionCallback(elementValue.OnEnter, "onEnter")
	return node
end

--- Mounts a fragment element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the fragment element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Fragment element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountFragmentNode(
	node: runtimeNode,
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(elementValue.Kind == "fragment", "Reactily fragment mount requires the matching element kind.")
	for _, child in elementValue.Children do
		node.Children[#node.Children + 1] = internals.mount(parent, child, options)
	end
	syncFragmentRef(node, elementValue.RefTarget)
	return node
end

--- Mounts a virtual element into a new runtime node.
--- @param parent Instance Roblox parent used for mounted host instances.
--- @param elementValue element Virtual element to mount.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return runtimeNode Newly mounted runtime node.
function internals.mount(parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
	local node: runtimeNode = {
		Children = {},
		Element = elementValue,
		ErrorValue = nil,
		FragmentHandle = nil,
		FragmentRefTarget = nil,
		HookContext = nil,
		Host = nil,
		IsSuspended = false,
		Parent = parent,
		SuspenseCleanup = nil,
		ViewTweens = nil,
	}
	local success, result = pcall(function(): runtimeNode
		if elementValue.Kind == "host" then
			return mountHostNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "component" then
			return mountComponentNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "portal" then
			return mountPortalNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "provider" then
			return mountProviderNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "errorBoundary" then
			return mountErrorBoundaryNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "suspense" then
			return mountSuspenseNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "activity" then
			return mountActivityNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "profiler" then
			return mountProfilerNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "strictMode" then
			return mountStrictModeNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "viewTransition" then
			return mountViewTransitionNode(node, parent, elementValue, options)
		end

		if elementValue.Kind == "fragment" then
			return mountFragmentNode(node, parent, elementValue, options)
		end

		for _, child in elementValue.Children do
			node.Children[#node.Children + 1] = internals.mount(parent, child, options)
		end
		return node
	end)
	if success then
		return result :: runtimeNode
	end
	internals.DeleteNode(node)
	error(result, 0)
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles a host node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next host element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileHostNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "host", "Reactily host reconcile requires the matching element kind.")
	local host = currentNode.Host
	assert(host, "Reactily host runtime node is missing its host handle.")
	assert(previousElement.Kind == "host", "Reactily host identity changed unexpectedly.")
	if host.Instance.Parent ~= parent then
		host.Instance.Parent = parent
	end
	renderer.UpdateHost(host, previousElement.Props, nextElement.Props)
	currentNode.Children =
		internals.ReconcileChildren(host.Instance, currentNode.Children, nextElement.Children, options)
	return currentNode
end

--- Reconciles a component node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next component element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileComponentNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "component", "Reactily component reconcile requires the matching element kind.")
	local hookContext = currentNode.HookContext
	assert(hookContext, "Reactily component runtime node is missing hook context.")
	assert(previousElement.Kind == "component", "Reactily component identity changed unexpectedly.")
	local propsChanged = memoModule.ShouldUpdate(nextElement.component, previousElement.Props, nextElement.Props)
	local childInputsChanged = not childrenEqual(previousElement.Children, nextElement.Children)
	if
		memoModule.IsMemo(nextElement.component)
		and not options.ForceRender
		and not hookContext.NeedsRender
		and not propsChanged
		and not childInputsChanged
	then
		return currentNode
	end
	local reason = options.RenderReason or "parent rendered"
	if propsChanged or childInputsChanged then
		reason = "props changed"
	end
	if not propsChanged and not childInputsChanged and hookContext.NeedsRender then
		reason = "component state changed"
	end
	local rendered = internals.RenderComponent(nextElement, hookContext, reason, options.StrictMode == true)
	local currentChild = currentNode.Children[1]
	local nextChild = internals.Reconcile(parent, currentChild, rendered, options)
	table.clear(currentNode.Children)
	if nextChild then
		currentNode.Children[1] = nextChild
	end
	flushComponentEffects(hookContext, options, false)
	return currentNode
end

--- Reconciles a portal node while preserving its specific lifecycle behavior.
--- @param _parent Instance Unused Roblox parent; portal children reconcile into their target.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param _previousElement element Unused previous element; portal reconciliation uses the new target.
--- @param nextElement element Next portal element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcilePortalNode(
	_parent: Instance,
	currentNode: runtimeNode,
	_previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "portal", "Reactily portal reconcile requires the matching element kind.")
	currentNode.Children =
		internals.ReconcileChildren(nextElement.target, currentNode.Children, nextElement.Children, options)
	return currentNode
end

--- Reconciles a provider node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next provider element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileProviderNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "provider", "Reactily provider reconcile requires the matching element kind.")
	assert(previousElement.Kind == "provider", "Reactily context-provider identity changed unexpectedly.")
	local childOptions = options
	if previousElement.ProvidedValue ~= nextElement.ProvidedValue then
		childOptions = table.clone(options)
		childOptions.ForceRender = true
		childOptions.RenderReason = "context changed"
	end
	currentNode.Children = withContext(nextElement.ContextValue, nextElement.ProvidedValue, function(): { runtimeNode }
		return internals.ReconcileChildren(parent, currentNode.Children, nextElement.Children, childOptions)
	end)
	return currentNode
end

--- Reconciles a errorBoundary node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next error boundary element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileErrorBoundaryNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "errorBoundary", "Reactily errorBoundary reconcile requires the matching element kind.")
	assert(previousElement.Kind == "errorBoundary", "Reactily error-boundary identity changed unexpectedly.")
	local child = nextElement.Children[1]
	local success, result = pcall(function(): runtimeNode?
		local currentChild: runtimeNode? = currentNode.Children[1]
		if currentNode.ErrorValue ~= nil then
			currentChild = nil
		end
		return internals.Reconcile(parent, currentChild, child, options)
	end)
	local childOrFailure: any = result
	if success then
		if currentNode.ErrorValue then
			for _, currentChild in currentNode.Children do
				internals.DeleteNode(currentChild)
			end
		end
		currentNode.ErrorValue = nil
		table.clear(currentNode.Children)
		if childOrFailure then
			currentNode.Children[1] = childOrFailure :: runtimeNode
		end
		return currentNode
	end
	if resourceModule.IsSuspension(childOrFailure) then
		error(childOrFailure, 0)
	end
	for _, currentChild in currentNode.Children do
		internals.DeleteNode(currentChild)
	end
	table.clear(currentNode.Children)
	currentNode.ErrorValue = childOrFailure
	if nextElement.OnError then
		nextElement.OnError(childOrFailure)
	end
	currentNode.Children[1] = internals.mount(parent, resolveFallback(nextElement, childOrFailure), options)
	return currentNode
end

--- Reconciles a suspense node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next Suspense element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileSuspenseNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "suspense", "Reactily suspense reconcile requires the matching element kind.")
	assert(previousElement.Kind == "suspense", "Reactily Suspense identity changed unexpectedly.")
	local child = nextElement.Children[1]
	local existing: runtimeNode? = currentNode.Children[1]
	if currentNode.IsSuspended and existing then
		internals.DeleteNode(existing)
		table.clear(currentNode.Children)
		existing = nil
	end
	local success, result = pcall(function(): runtimeNode?
		return internals.Reconcile(parent, existing, child, options)
	end)
	local childOrFailure: any = result
	if success then
		disconnectSuspense(currentNode)
		currentNode.IsSuspended = false
		table.clear(currentNode.Children)
		if childOrFailure then
			currentNode.Children[1] = childOrFailure :: runtimeNode
		end
		return currentNode
	end
	if not resourceModule.IsSuspension(childOrFailure) then
		error(childOrFailure, 0)
	end
	if existing then
		internals.DeleteNode(existing)
	end
	table.clear(currentNode.Children)
	local suspension: resourceModule.suspension = childOrFailure
	currentNode.IsSuspended = true
	subscribeSuspense(currentNode, suspension, options)
	currentNode.Children[1] = internals.mount(parent, nextElement.Fallback, options)
	return currentNode
end

--- Reconciles a activity node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next Activity element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileActivityNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "activity", "Reactily activity reconcile requires the matching element kind.")
	assert(previousElement.Kind == "activity", "Reactily Activity identity changed unexpectedly.")
	local childOptions = table.clone(options)
	local hidden = options.HiddenActivity == true or nextElement.Mode == "hidden"
	childOptions.HiddenActivity = hidden
	currentNode.Children = internals.ReconcileChildren(parent, currentNode.Children, nextElement.Children, childOptions)
	setActivityHidden(currentNode, hidden, true)
	return currentNode
end

--- Reconciles a profiler node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next Profiler element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileProfilerNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "profiler", "Reactily profiler reconcile requires the matching element kind.")
	assert(previousElement.Kind == "profiler", "Reactily Profiler identity changed unexpectedly.")
	local started = os.clock()
	local child = nextElement.Children[1]
	local currentChild = currentNode.Children[1]
	local nextChild = internals.Reconcile(parent, currentChild, child, options)
	table.clear(currentNode.Children)
	if nextChild then
		currentNode.Children[1] = nextChild
	end
	local duration = os.clock() - started
	if nextElement.OnRender then
		nextElement.OnRender(nextElement.Id, "update", duration, options.RenderReason or "parent rendered")
	end
	return currentNode
end

--- Reconciles a strictMode node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next StrictMode element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileStrictModeNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "strictMode", "Reactily strictMode reconcile requires the matching element kind.")
	assert(previousElement.Kind == "strictMode", "Reactily StrictMode identity changed unexpectedly.")
	local childOptions = table.clone(options)
	childOptions.StrictMode = true
	currentNode.Children = internals.ReconcileChildren(parent, currentNode.Children, nextElement.Children, childOptions)
	return currentNode
end

--- Reconciles a viewTransition node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next ViewTransition element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileViewTransitionNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "viewTransition", "Reactily viewTransition reconcile requires the matching element kind.")
	assert(previousElement.Kind == "viewTransition", "Reactily ViewTransition identity changed unexpectedly.")
	if currentNode.ViewTweens then
		viewTransitionModule.Cancel(currentNode.ViewTweens)
	end
	local beforeInstances = collectNodeInstances(currentNode)
	local before = viewTransitionModule.Capture(beforeInstances)
	local child = nextElement.Children[1]
	local currentChild = currentNode.Children[1]
	local nextChild = internals.Reconcile(parent, currentChild, child, options)
	table.clear(currentNode.Children)
	if nextChild then
		currentNode.Children[1] = nextChild
	end
	local afterInstances = collectNodeInstances(currentNode)
	currentNode.ViewTweens = viewTransitionModule.PlayUpdate(before, afterInstances, nextElement.Config)
	runViewTransitionCallback(nextElement.OnUpdate, "onUpdate")
	return currentNode
end

--- Reconciles a fragment node while preserving its specific lifecycle behavior.
--- @param parent Instance Roblox Instance that receives reconciled descendants.
--- @param currentNode runtimeNode Existing mounted runtime node to update.
--- @param previousElement element Previously rendered element used to compare lifecycle state.
--- @param nextElement element Next fragment element to render.
--- @param options reconcileOptions Reconciliation options and render metadata.
--- @return runtimeNode Updated runtime node.
local function reconcileFragmentNode(
	parent: Instance,
	currentNode: runtimeNode,
	previousElement: elementModule.element,
	nextElement: elementModule.element,
	options: reconcileOptions
): runtimeNode
	assert(nextElement.Kind == "fragment", "Reactily fragment reconcile requires the matching element kind.")
	assert(previousElement.Kind == "fragment", "Reactily Fragment identity changed unexpectedly.")
	currentNode.Children = internals.ReconcileChildren(parent, currentNode.Children, nextElement.Children, options)
	syncFragmentRef(currentNode, nextElement.RefTarget)
	return currentNode
end

--- Reconciles one virtual element against an existing runtime node.
--- @param parent Instance Roblox parent for the reconciled subtree.
--- @param currentNode runtimeNode? Existing runtime node.
--- @param nextElement element? Desired next element.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return runtimeNode? Reused, replaced, mounted, or removed runtime node.
function internals.Reconcile(
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
		internals.DeleteNode(currentNode)
		return nil
	end
	if not internals.SameIdentity(currentNode.Element, nextElement) then
		internals.DeleteNode(currentNode)
		return internals.mount(parent, nextElement, options)
	end
	local previousElement = currentNode.Element
	currentNode.Element = nextElement
	currentNode.Parent = parent
	if nextElement.Kind == "host" then
		return reconcileHostNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "component" then
		return reconcileComponentNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "portal" then
		return reconcilePortalNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "provider" then
		return reconcileProviderNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "errorBoundary" then
		return reconcileErrorBoundaryNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "suspense" then
		return reconcileSuspenseNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "activity" then
		return reconcileActivityNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "profiler" then
		return reconcileProfilerNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "strictMode" then
		return reconcileStrictModeNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "viewTransition" then
		return reconcileViewTransitionNode(parent, currentNode, previousElement, nextElement, options)
	end

	if nextElement.Kind == "fragment" then
		return reconcileFragmentNode(parent, currentNode, previousElement, nextElement, options)
	end

	currentNode.Children = internals.ReconcileChildren(parent, currentNode.Children, nextElement.Children, options)
	return currentNode
end

--————————————————————————————————————————————————————————————————————--

--- Reconciles a child list while preserving keyed identity and positional unkeyed identity.
--- @param parent Instance Roblox parent for the child subtree.
--- @param currentChildren {runtimeNode} Existing runtime children.
--- @param nextChildren {element} Desired child elements.
--- @param options reconcileOptions Reconciliation callbacks and render metadata.
--- @return {runtimeNode} Reconciled child runtime nodes.
function internals.ReconcileChildren(
	parent: Instance,
	currentChildren: { runtimeNode },
	nextChildren: { elementModule.element },
	options: reconcileOptions
): { runtimeNode }
	local currentByKey: { [string]: runtimeNode } = {}
	local currentWithoutKey: { runtimeNode } = {}
	local nextKeys: { [string]: boolean } = {}
	local originalNodes: { [runtimeNode]: boolean } = {}
	local output: { runtimeNode } = table.create(#nextChildren)
	local usedNodes: { [runtimeNode]: boolean } = {}
	for _, currentNode in currentChildren do
		originalNodes[currentNode] = true
		local key = getElementKey(currentNode.Element)
		if not key then
			currentWithoutKey[#currentWithoutKey + 1] = currentNode
			continue
		end
		assert(not currentByKey[key], `Reactily current children contain duplicate key "{key}".`)
		currentByKey[key] = currentNode
	end
	local success, failure = pcall(function(): boolean
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
			local nextNode = internals.Reconcile(parent, currentNode, nextElement, options)
			if nextNode then
				output[#output + 1] = nextNode
			end
		end

		return true
	end)
	if not success then
		for _, outputNode in output do
			if originalNodes[outputNode] then
				continue
			end
			internals.DeleteNode(outputNode)
		end
		table.clear(currentByKey)
		table.clear(currentWithoutKey)
		table.clear(nextKeys)
		table.clear(originalNodes)
		table.clear(output)
		table.clear(usedNodes)
		error(failure, 0)
	end
	for _, currentNode in currentChildren do
		if usedNodes[currentNode] then
			continue
		end
		internals.DeleteNode(currentNode)
	end
	table.clear(currentByKey)
	table.clear(currentChildren)
	table.clear(currentWithoutKey)
	table.clear(nextKeys)
	table.clear(originalNodes)
	table.clear(usedNodes)
	return output
end

--————————————————————————————————————————————————————————————————————--

--- Renders a component while managing hook context and profiler diagnostics.
--- @param elementValue element Component element to render.
--- @param context componentContext Hook context owned by the component.
--- @param reason string Diagnostic reason for the render.
--- @param strictMode boolean? Whether this render is inside StrictMode.
--- @return element? Element returned by the component.
function internals.RenderComponent(
	elementValue: elementModule.element,
	context: hooks.componentContext,
	reason: string,
	strictMode: boolean?
): elementModule.element?
	assert(elementValue.Kind == "component", "Reactily component renderer requires a component element.")
	local props = table.clone(elementValue.Props)
	props.Children = elementValue.Children
	if strictMode and strictModeModule.IsEnabled() and not context.IsRendered then
		local previewContext = hooks.NewContext(function()
			strictModeModule.Warn("A component requested state during the StrictMode preview render.")
		end)
		hooks.BeginRender(previewContext)
		local previewSuccess, previewResult = pcall(elementValue.component, table.clone(props))
		hooks.EndRender(previewContext, previewSuccess)
		hooks.DeleteContext(previewContext)
		if not previewSuccess then
			error(previewResult, 0)
		end
	end
	hooks.BeginRender(context)
	local started = os.clock()
	local success, result = pcall(elementValue.component, props)
	local duration = os.clock() - started
	hooks.EndRender(context, success)
	profiler.Record(elementValue.component, duration, reason)
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
function internals.SameIdentity(current: elementModule.element, nextValue: elementModule.element): boolean
	if current.Kind ~= nextValue.Kind then
		return false
	end
	if current.Key ~= nextValue.Key then
		return false
	end
	if current.Kind == "host" and nextValue.Kind == "host" then
		return current.ClassName == nextValue.ClassName
	end
	if current.Kind == "component" and nextValue.Kind == "component" then
		return current.component == nextValue.component
	end
	if current.Kind == "provider" and nextValue.Kind == "provider" then
		return current.ContextValue == nextValue.ContextValue
	end
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a reconciled runtime tree.
--- @param node runtimeNode? Root runtime node.
--- @return boolean True when a node was deleted.
function module.Delete(node: runtimeNode?): boolean
	if not node then
		return false
	end
	internals.DeleteNode(node)
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Returns a recursive diagnostic snapshot of a runtime tree.
--- @param node runtimeNode? Root runtime node.
--- @return nodeSnapshot? Snapshot suitable for development tooling.
function module.Inspect(node: runtimeNode?): nodeSnapshot?
	if not node then
		return nil
	end
	local snapshot: nodeSnapshot = {
		Children = {},
		Key = node.Element.Key,
		Kind = node.Element.Kind,
		Suspended = node.IsSuspended,
	}
	if node.Element.Kind == "host" then
		snapshot.ClassName = node.Element.ClassName
		if node.Host then
			snapshot.Instance = node.Host.Instance
		end
	end
	for _, child in node.Children do
		local childSnapshot = module.Inspect(child)
		if childSnapshot then
			snapshot.Children[#snapshot.Children + 1] = childSnapshot
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
function module.Reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	return internals.Reconcile(parent, currentNode, nextElement, options)
end

--————————————————————————————————————————————————————————————————————--
return module
