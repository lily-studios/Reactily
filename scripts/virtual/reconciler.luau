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
   forceRender: boolean?,
   hiddenActivity: boolean?,
   renderReason: string?,
   requestRender: (reason: string?) -> (),
   strictMode: boolean?,
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
   fragmentHandle: fragmentRefModule.fragmentInstance?,
   fragmentRefTarget: fragmentRefModule.refTarget?,
   hookContext: hooks.componentContext?,
   host: renderer.hostHandle?,
   isSuspended: boolean,
   parent: Instance,
   suspenseCleanup: (() -> ())?,
   viewTweens: { Tween }?,
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
--- Recursively collects Roblox host instances from a mounted subtree.
--- @param node runtimeNode Root runtime node to traverse.
--- @param output {Instance} Mutable array receiving every discovered host instance.
local function collectAllHostInstances(node: runtimeNode, output: { Instance })
   if node.host then
      output[#output + 1] = node.host.instance
   end
   for _, child in node.children do
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
      if node.host then
         output[#output + 1] = node.host.instance
         return
      end
      for _, child in node.children do
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
   if node.host then
      renderer.replayRef(node.host)
   end
   for _, child in node.children do
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
   if
      not hidden
      and not isBoundaryRoot
      and node.element.kind == "activity"
      and node.element.mode == "hidden"
   then
      return
   end
   if node.host then
      if hidden then
         activityModule.hide(node.host.instance)
      else
         activityModule.show(node.host.instance)
      end
   end
   if node.hookContext then
      if hidden then
         hooks.pauseEffects(node.hookContext)
      else
         hooks.resumeEffects(node.hookContext)
      end
   end
   for _, child in node.children do
      setActivityHidden(child, hidden, false)
   end
end
--- Updates a fragment ref and refreshes its mounted-instance view.
--- @param node runtimeNode Fragment runtime node that owns the ref handle.
--- @param target refTarget? Desired ref target, or nil to detach the old ref.
local function syncFragmentRef(node: runtimeNode, target: fragmentRefModule.refTarget?)
   if node.fragmentRefTarget == target and node.fragmentHandle then
      node.fragmentHandle.refresh()
      return
   end
   if node.fragmentRefTarget then
      fragmentRefModule.assign(node.fragmentRefTarget, nil)
   end
   if not node.fragmentHandle then
      node.fragmentHandle = fragmentRefModule.new(function(): { Instance }
         return collectFirstLevelHostInstances(node.children)
      end)
   end
   node.fragmentRefTarget = target
   if target then
      fragmentRefModule.assign(target, node.fragmentHandle)
   end
end
--- Flushes component effects or pauses them for a hidden Activity.
--- @param context componentContext Component hook state that owns the effects.
--- @param options reconcileOptions Render options including Activity and StrictMode state.
--- @param replayStrict boolean Whether StrictMode should replay effects on this flush.
local function flushComponentEffects(context: hooks.componentContext, options: reconcileOptions, replayStrict: boolean)
   if options.hiddenActivity then
      hooks.pauseEffects(context)
      return
   end
   hooks.flushInsertionEffects(context)
   hooks.flushLayoutEffects(context)
   hooks.flushEffects(context)
   if replayStrict and options.strictMode and strictModeModule.isEnabled() then
      hooks.replayEffects(context)
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
function internals.deleteNode(node: runtimeNode)
   disconnectSuspense(node)
   if node.element.kind == "viewTransition" then
      runViewTransitionCallback(node.element.onExit, "onExit")
      if node.viewTweens then
         viewTransitionModule.cancel(node.viewTweens)
         node.viewTweens = nil
      end
   end
   if node.fragmentRefTarget then
      fragmentRefModule.assign(node.fragmentRefTarget, nil)
      node.fragmentRefTarget = nil
   end
   if node.fragmentHandle then
      node.fragmentHandle.delete()
      node.fragmentHandle = nil
   end
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

--- Mounts a host element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the host element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Host element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountHostNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "host", "Reactily host mount requires the matching element kind.")
   local host = renderer.createHost(parent, elementValue)
   node.host = host
   for _, child in elementValue.children do
      node.children[#node.children + 1] = internals.mount(host.instance, child, options)
   end
   return node
end

--- Mounts a component element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the component element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Component element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountComponentNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "component", "Reactily component mount requires the matching element kind.")
   local hookContext = hooks.newContext(options.requestRender)
   node.hookContext = hookContext
   local rendered = internals.renderComponent(
      elementValue,
      hookContext,
      options.renderReason or "mount",
      options.strictMode == true
   )
   if rendered then
      node.children[1] = internals.mount(parent, rendered, options)
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
local function mountPortalNode(node: runtimeNode, _parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "portal", "Reactily portal mount requires the matching element kind.")
   for _, child in elementValue.children do
      node.children[#node.children + 1] = internals.mount(elementValue.target, child, options)
   end
   return node
end

--- Mounts a provider element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the provider element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Provider element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountProviderNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "provider", "Reactily provider mount requires the matching element kind.")
   node.children = withContext(elementValue.contextValue, elementValue.providedValue, function(): { runtimeNode }
      local output: { runtimeNode } = {}
      for _, child in elementValue.children do
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
local function mountErrorBoundaryNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "errorBoundary", "Reactily errorBoundary mount requires the matching element kind.")
   local child = elementValue.children[1]
   local childSuccess, childResult = pcall(function(): runtimeNode
      return internals.mount(parent, child, options)
   end)
   local childOrFailure: any = childResult
   if childSuccess then
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

--- Mounts a suspense element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the Suspense element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Suspense element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountSuspenseNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "suspense", "Reactily suspense mount requires the matching element kind.")
   local child = elementValue.children[1]
   local suspenseSuccess, suspenseResult = pcall(function(): runtimeNode
      return internals.mount(parent, child, options)
   end)
   local childOrFailure: any = suspenseResult
   if suspenseSuccess then
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

--- Mounts a activity element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the Activity element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Activity element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountActivityNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "activity", "Reactily activity mount requires the matching element kind.")
   local childOptions = table.clone(options)
   childOptions.hiddenActivity = options.hiddenActivity == true or elementValue.mode == "hidden"
   for _, child in elementValue.children do
      node.children[#node.children + 1] = internals.mount(parent, child, childOptions)
   end
   if childOptions.hiddenActivity then
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
local function mountProfilerNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "profiler", "Reactily profiler mount requires the matching element kind.")
   local child = elementValue.children[1]
   local started = os.clock()
   node.children[1] = internals.mount(parent, child, options)
   local duration = os.clock() - started
   if elementValue.onRender then
      elementValue.onRender(elementValue.id, "mount", duration, options.renderReason or "mount")
   end
   return node
end

--- Mounts a strictMode element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the StrictMode element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Strictmode element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountStrictModeNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "strictMode", "Reactily strictMode mount requires the matching element kind.")
   local childOptions = table.clone(options)
   childOptions.strictMode = true
   for _, child in elementValue.children do
      node.children[#node.children + 1] = internals.mount(parent, child, childOptions)
   end
   if strictModeModule.isEnabled() then
      for _, childNode in node.children do
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
local function mountViewTransitionNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "viewTransition", "Reactily viewTransition mount requires the matching element kind.")
   local child = elementValue.children[1]
   node.children[1] = internals.mount(parent, child, options)
   local instances = collectNodeInstances(node)
   node.viewTweens = viewTransitionModule.playEnter(instances, elementValue.config)
   runViewTransitionCallback(elementValue.onEnter, "onEnter")
   return node
end

--- Mounts a fragment element using its dedicated lifecycle path.
--- @param node runtimeNode Newly allocated runtime node for the fragment element.
--- @param parent Instance Roblox Instance that receives mounted descendants.
--- @param elementValue element Fragment element to mount.
--- @param options reconcileOptions Render request options and lifecycle callbacks.
--- @return runtimeNode Mounted runtime node.
local function mountFragmentNode(node: runtimeNode, parent: Instance, elementValue: elementModule.element, options: reconcileOptions): runtimeNode
   assert(elementValue.kind == "fragment", "Reactily fragment mount requires the matching element kind.")
   for _, child in elementValue.children do
      node.children[#node.children + 1] = internals.mount(parent, child, options)
   end
   syncFragmentRef(node, elementValue.refTarget)
   return node
end

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
      fragmentHandle = nil,
      fragmentRefTarget = nil,
      hookContext = nil,
      host = nil,
      isSuspended = false,
      parent = parent,
      suspenseCleanup = nil,
      viewTweens = nil,
   }
   local success, result = pcall(function(): runtimeNode
      if elementValue.kind == "host" then
         return mountHostNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "component" then
         return mountComponentNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "portal" then
         return mountPortalNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "provider" then
         return mountProviderNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "errorBoundary" then
         return mountErrorBoundaryNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "suspense" then
         return mountSuspenseNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "activity" then
         return mountActivityNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "profiler" then
         return mountProfilerNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "strictMode" then
         return mountStrictModeNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "viewTransition" then
         return mountViewTransitionNode(node, parent, elementValue, options)
      end

      if elementValue.kind == "fragment" then
         return mountFragmentNode(node, parent, elementValue, options)
      end

      for _, child in elementValue.children do
         node.children[#node.children + 1] = internals.mount(parent, child, options)
      end
      return node
   end)
   if success then
      return result :: runtimeNode
   end
   internals.deleteNode(node)
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
   assert(nextElement.kind == "host", "Reactily host reconcile requires the matching element kind.")
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
   assert(nextElement.kind == "component", "Reactily component reconcile requires the matching element kind.")
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
   local rendered = internals.renderComponent(nextElement, hookContext, reason, options.strictMode == true)
   local currentChild = currentNode.children[1]
   local nextChild = internals.reconcile(parent, currentChild, rendered, options)
   table.clear(currentNode.children)
   if nextChild then
      currentNode.children[1] = nextChild
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
   assert(nextElement.kind == "portal", "Reactily portal reconcile requires the matching element kind.")
   currentNode.children =
      internals.reconcileChildren(nextElement.target, currentNode.children, nextElement.children, options)
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
   assert(nextElement.kind == "provider", "Reactily provider reconcile requires the matching element kind.")
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
   assert(nextElement.kind == "errorBoundary", "Reactily errorBoundary reconcile requires the matching element kind.")
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
   assert(nextElement.kind == "suspense", "Reactily suspense reconcile requires the matching element kind.")
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
   assert(nextElement.kind == "activity", "Reactily activity reconcile requires the matching element kind.")
   assert(previousElement.kind == "activity", "Reactily Activity identity changed unexpectedly.")
   local childOptions = table.clone(options)
   local hidden = options.hiddenActivity == true or nextElement.mode == "hidden"
   childOptions.hiddenActivity = hidden
   currentNode.children =
      internals.reconcileChildren(parent, currentNode.children, nextElement.children, childOptions)
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
   assert(nextElement.kind == "profiler", "Reactily profiler reconcile requires the matching element kind.")
   assert(previousElement.kind == "profiler", "Reactily Profiler identity changed unexpectedly.")
   local started = os.clock()
   local child = nextElement.children[1]
   local currentChild = currentNode.children[1]
   local nextChild = internals.reconcile(parent, currentChild, child, options)
   table.clear(currentNode.children)
   if nextChild then
      currentNode.children[1] = nextChild
   end
   local duration = os.clock() - started
   if nextElement.onRender then
      nextElement.onRender(nextElement.id, "update", duration, options.renderReason or "parent rendered")
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
   assert(nextElement.kind == "strictMode", "Reactily strictMode reconcile requires the matching element kind.")
   assert(previousElement.kind == "strictMode", "Reactily StrictMode identity changed unexpectedly.")
   local childOptions = table.clone(options)
   childOptions.strictMode = true
   currentNode.children =
      internals.reconcileChildren(parent, currentNode.children, nextElement.children, childOptions)
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
   assert(nextElement.kind == "viewTransition", "Reactily viewTransition reconcile requires the matching element kind.")
   assert(previousElement.kind == "viewTransition", "Reactily ViewTransition identity changed unexpectedly.")
   if currentNode.viewTweens then
      viewTransitionModule.cancel(currentNode.viewTweens)
   end
   local beforeInstances = collectNodeInstances(currentNode)
   local before = viewTransitionModule.capture(beforeInstances)
   local child = nextElement.children[1]
   local currentChild = currentNode.children[1]
   local nextChild = internals.reconcile(parent, currentChild, child, options)
   table.clear(currentNode.children)
   if nextChild then
      currentNode.children[1] = nextChild
   end
   local afterInstances = collectNodeInstances(currentNode)
   currentNode.viewTweens = viewTransitionModule.playUpdate(before, afterInstances, nextElement.config)
   runViewTransitionCallback(nextElement.onUpdate, "onUpdate")
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
   assert(nextElement.kind == "fragment", "Reactily fragment reconcile requires the matching element kind.")
   assert(previousElement.kind == "fragment", "Reactily Fragment identity changed unexpectedly.")
   currentNode.children =
      internals.reconcileChildren(parent, currentNode.children, nextElement.children, options)
   syncFragmentRef(currentNode, nextElement.refTarget)
   return currentNode
end

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
      return reconcileHostNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "component" then
      return reconcileComponentNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "portal" then
      return reconcilePortalNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "provider" then
      return reconcileProviderNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "errorBoundary" then
      return reconcileErrorBoundaryNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "suspense" then
      return reconcileSuspenseNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "activity" then
      return reconcileActivityNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "profiler" then
      return reconcileProfilerNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "strictMode" then
      return reconcileStrictModeNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "viewTransition" then
      return reconcileViewTransitionNode(parent, currentNode, previousElement, nextElement, options)
   end

   if nextElement.kind == "fragment" then
      return reconcileFragmentNode(parent, currentNode, previousElement, nextElement, options)
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
   local originalNodes: { [runtimeNode]: boolean } = {}
   local output: { runtimeNode } = table.create(#nextChildren)
   local usedNodes: { [runtimeNode]: boolean } = {}
   for _, currentNode in currentChildren do
      originalNodes[currentNode] = true
      local key = getElementKey(currentNode.element)
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
         local nextNode = internals.reconcile(parent, currentNode, nextElement, options)
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
         internals.deleteNode(outputNode)
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
      internals.deleteNode(currentNode)
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
function internals.renderComponent(
   elementValue: elementModule.element,
   context: hooks.componentContext,
   reason: string,
   strictMode: boolean?
): elementModule.element?
   assert(elementValue.kind == "component", "Reactily component renderer requires a component element.")
   local props = table.clone(elementValue.props)
   props.children = elementValue.children
   if strictMode and strictModeModule.isEnabled() and not context.isRendered then
      local previewContext = hooks.newContext(function()
         strictModeModule.warn("A component requested state during the StrictMode preview render.")
      end)
      hooks.beginRender(previewContext)
      local previewSuccess, previewResult = pcall(elementValue.component, table.clone(props))
      hooks.endRender(previewContext, previewSuccess)
      hooks.deleteContext(previewContext)
      if not previewSuccess then
         error(previewResult, 0)
      end
   end
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
