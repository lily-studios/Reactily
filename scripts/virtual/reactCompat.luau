
--[[
  Reactily · Lily Studios

  Copyright (c) Lily Studios and contributors.
  Licensed under the MIT License.
  See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local childrenModule = require(script.Parent.child)
local elementModule = require(script.Parent.element)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- Properties for the StrictMode component.
--- @field children {any}? Child elements rendered inside StrictMode.
--- @field key string? Optional reconciliation key.
export type strictModeProps = {
    children: { any }?,
    key: string?,
}

--- Properties for the Suspense component.
--- @field fallback element Element displayed while the child is suspended.
--- @field children {any}? Child elements managed by Suspense.
--- @field key string? Optional reconciliation key.
export type suspenseProps = {
    fallback: elementModule.element,
    children: { any }?,
    key: string?,
}

--- Properties for the ErrorBoundary component.
--- @field fallback element | function Fallback element or error handler that produces an element.
--- @field onError function? Callback invoked when a child error is captured.
--- @field children {any}? Child elements protected by the error boundary.
--- @field key string? Optional reconciliation key.
export type errorBoundaryProps = {
    fallback: elementModule.element | ((failure: any) -> elementModule.element),
    onError: ((failure: any) -> ())?,
    children: { any }?,
    key: string?,
}

--- Properties for the Activity component.
--- @field children {any}? Child elements managed by Activity.
--- @field key string? Optional reconciliation key.
--- @field mode activityMode? Visibility mode for the subtree.
export type activityProps = {
    children: { any }?,
    key: string?,
    mode: elementModule.activityMode?,
}

--- Properties for the Profiler component.
--- @field children {any}? Child elements measured by the profiler.
--- @field id string Identifier used in profiler reports.
--- @field key string? Optional reconciliation key.
--- @field onRender profilerOnRender? Callback invoked after rendering.
export type profilerProps = {
    children: { any }?,
    id: string,
    key: string?,
    onRender: elementModule.profilerOnRender?,
}

--- Properties for the ViewTransition component.
--- @field children {any}? Child elements participating in transitions.
--- @field config viewTransitionConfig? Animation configuration.
--- @field key string? Optional reconciliation key.
--- @field onEnter function? Callback invoked when the transition enters.
--- @field onExit function? Callback invoked when the transition exits.
--- @field onUpdate function? Callback invoked when the transition updates.
export type viewTransitionProps = {
    children: { any }?,
    config: elementModule.viewTransitionConfig?,
    key: string?,
    onEnter: (() -> ())?,
    onExit: (() -> ())?,
    onUpdate: (() -> ())?,
}

--————————————————————————————————————————————————————————————————————--

--- React-style StrictMode wrapper with development-only purity/effect checks.
--- @param props strictModeProps StrictMode component properties.
--- @return element Created StrictMode element.
function module.StrictMode(props: strictModeProps): elementModule.element
    return elementModule.createStrictMode(props.children or {}, props.key)
end

--————————————————————————————————————————————————————————————————————--

--- React-style Suspense function component wrapper.
--- @param props suspenseProps Suspense component properties.
--- @return element Created Suspense element.
function module.Suspense(props: suspenseProps): elementModule.element
    local child = childrenModule.only(props.children or {})
    return elementModule.createSuspense(props.fallback, child, props.key)
end

--————————————————————————————————————————————————————————————————————--

--- Reactily error-boundary function component wrapper.
--- @param props errorBoundaryProps ErrorBoundary component properties.
--- @return element Created error-boundary element.
function module.ErrorBoundary(props: errorBoundaryProps): elementModule.element
    local child = childrenModule.only(props.children or {})
    return elementModule.createErrorBoundary(props.fallback, child, props.onError, props.key)
end

--————————————————————————————————————————————————————————————————————--

--- Hides/restores a subtree while preserving mounted hook state.
--- @param props activityProps Activity component properties.
--- @return element Created Activity element.
function module.Activity(props: activityProps): elementModule.element
    return elementModule.createActivity(props.mode or "visible", props.children or {}, props.key)
end

--————————————————————————————————————————————————————————————————————--

--- Measures render/reconciliation time for one subtree.
--- @param props profilerProps Profiler component properties.
--- @return element Created Profiler element.
function module.Profiler(props: profilerProps): elementModule.element
    local child = childrenModule.only(props.children or {})
    return elementModule.createProfiler(props.id, child, props.onRender, props.key)
end

--————————————————————————————————————————————————————————————————————--

--- Roblox-native ViewTransition wrapper for animated host mutations.
--- @param props viewTransitionProps ViewTransition component properties.
--- @return element Created ViewTransition element.
function module.ViewTransition(props: viewTransitionProps): elementModule.element
    local child = childrenModule.only(props.children or {})
    return elementModule.createViewTransition(
        child,
        props.config,
        props.onEnter,
        props.onExit,
        props.onUpdate,
        props.key
    )
end

--————————————————————————————————————————————————————————————————————--

return module
