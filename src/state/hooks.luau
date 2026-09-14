--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local animationModule = require(script.Parent.Parent.runtime.animation)
local bindingModule = require(script.Parent.Parent.runtime.binding)
local contextModule = require(script.Parent.context)
local devMode = require(script.Parent.Parent.core.devMode)
local springModule = require(script.Parent.Parent.runtime.spring)
local storeModule = require(script.Parent.store)
local transitionModule = require(script.Parent.Parent.runtime.transition)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

type cleanup = () -> ()
type dependencyList = { any }
type effectCallback = (() -> ()) | (() -> cleanup?)

type hookSlot = {
	callback: any,
	cleanup: cleanup?,
	dependencies: dependencyList?,
	isInitialized: boolean,
	kind: string,
	value: any,
}

type pendingEffect = {
	callback: effectCallback,
	slot: hookSlot,
}

export type componentContext = {
	hookIndex: number,
	hooks: { hookSlot },
	isDeleted: boolean,
	isRendered: boolean,
	needsRender: boolean,
	pendingEffects: { pendingEffect },
	pendingLayoutEffects: { pendingEffect },
	renderedHookCount: number,
	requestRender: (reason: string?) -> (),
}

export type controllableStateOptions<T> = {
	defaultValue: T,
	onChanged: ((value: T) -> ())?,
	value: T?,
}

export type counterControls = {
	decrement: (amount: number?) -> (),
	increment: (amount: number?) -> (),
	reset: () -> (),
	set: (value: number) -> (),
}
export type reducerDispatch<A> = (action: A) -> ()
export type ref<T> = { current: T }

export type refTarget<T> = ref<T?> | ((value: T?) -> ())
export type stateSetter<T> = (value: T | ((previous: T) -> T)) -> ()
export type transitionStarter = (callback: () -> ()) -> ()

--————————————————————————————————————————————————————————————————————--

local currentContext: componentContext? = nil
local nextHookId = 0

--————————————————————————————————————————————————————————————————————--

local function createDependencies(...: any): dependencyList
	return { ... }
end

--————————————————————————————————————————————————————————————————————--

local function dependenciesChanged(previous: dependencyList?, current: dependencyList?): boolean
	if previous == nil then
		return true
	end
	if current == nil then
		return true
	end
	if #previous ~= #current then
		return true
	end
	for index, value in current do
		if previous[index] == value then
			continue
		end
		return true
	end
	return false
end

--————————————————————————————————————————————————————————————————————--

local function getContext(): componentContext
	local context = currentContext
	assert(context, "Reactily hook called outside a component render.")
	assert(not context.isDeleted, "Reactily component context is deleted.")
	return context
end

--————————————————————————————————————————————————————————————————————--

local function getSlot(context: componentContext, kind: string): hookSlot
	context.hookIndex += 1
	local existingSlot = context.hooks[context.hookIndex]
	if existingSlot then
		assert(existingSlot.kind == kind, `Reactily hook order changed from "{existingSlot.kind}" to "{kind}".`)
		return existingSlot
	end
	local slot: hookSlot = {
		callback = nil,
		cleanup = nil,
		dependencies = nil,
		isInitialized = false,
		kind = kind,
		value = nil,
	}
	context.hooks[context.hookIndex] = slot
	return slot
end

--————————————————————————————————————————————————————————————————————--

local function runCleanup(callback: cleanup)
	local success, failure = pcall(function(): boolean
		callback()
		return true
	end)
	if success then
		return
	end
	warn(`Reactily effect cleanup failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

local function resolveStateValue<T>(previous: T, nextValue: T | ((previous: T) -> T)): T
	if type(nextValue) == "function" then
		return (nextValue :: (previous: T) -> T)(previous)
	end
	return nextValue :: T
end

--————————————————————————————————————————————————————————————————————--

local function queueEffect(
	slot: hookSlot,
	callback: effectCallback,
	dependencies: dependencyList?,
	queue: { pendingEffect }
)
	if slot.isInitialized and not dependenciesChanged(slot.dependencies, dependencies) then
		return
	end
	slot.isInitialized = true
	slot.dependencies = nil
	if dependencies then
		slot.dependencies = table.clone(dependencies)
	end
	queue[#queue + 1] = {
		callback = callback,
		slot = slot,
	}
end

--————————————————————————————————————————————————————————————————————--

local function flushEffectQueue(context: componentContext, queueName: "pendingEffects" | "pendingLayoutEffects")
	if context.isDeleted then
		return
	end
	local queue = context[queueName]
	if #queue == 0 then
		return
	end
	context[queueName] = {}
	for _, effect in queue do
		if effect.slot.cleanup then
			runCleanup(effect.slot.cleanup)
			effect.slot.cleanup = nil
		end
		local cleanupValue: any = nil
		local success, failure = pcall(function(): boolean
			cleanupValue = (effect.callback :: any)()
			return true
		end)
		if success then
			if cleanupValue ~= nil and type(cleanupValue) ~= "function" then
				warn("Reactily effect callback must return a cleanup function or nil.")
				continue
			end
			effect.slot.cleanup = cleanupValue :: cleanup?
			continue
		end
		warn(`Reactily effect failed: {failure}`)
	end
	table.clear(queue)
end

--————————————————————————————————————————————————————————————————————--

local function setRefTarget<T>(target: refTarget<T>?, value: T?)
	if not target then
		return
	end
	if type(target) == "function" then
		(target :: (T?) -> ())(value)
		return
	end
	(target :: ref<T?>).current = value
end

--————————————————————————————————————————————————————————————————————--

--- Begins a component render using the provided hook context.
--- @param context componentContext Component context entering the render phase.
function module.beginRender(context: componentContext)
	assert(not context.isDeleted, "Reactily component context is deleted.")
	assert(currentContext == nil, "Reactily component renders cannot overlap.")
	context.hookIndex = 0
	currentContext = context
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a component context and releases its owned hook resources.
--- @param context componentContext Component context to delete.
--- @return boolean Whether the context was deleted.
function module.deleteContext(context: componentContext): boolean
	if context.isDeleted then
		return false
	end
	context.isDeleted = true
	for _, slot in context.hooks do
		if slot.cleanup then
			runCleanup(slot.cleanup)
			slot.cleanup = nil
		end
		slot.callback = nil
		slot.dependencies = nil
		slot.value = nil
	end
	table.clear(context.hooks)
	table.clear(context.pendingEffects)
	table.clear(context.pendingLayoutEffects)
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Completes the active component render.
--- @param context componentContext Component context completing the render.
--- @param didComplete boolean Whether the render completed successfully.
function module.endRender(context: componentContext, didComplete: boolean)
	assert(currentContext == context, "Reactily render context does not match the active component.")
	currentContext = nil
	if not didComplete then
		table.clear(context.pendingEffects)
		table.clear(context.pendingLayoutEffects)
		if not context.isRendered then
			table.clear(context.hooks)
			return
		end
		for index = #context.hooks, context.renderedHookCount + 1, -1 do
			table.remove(context.hooks, index)
		end
		return
	end
	if context.isRendered then
		assert(context.hookIndex == context.renderedHookCount, "Reactily hook count changed between renders.")
	end
	context.isRendered = true
	context.needsRender = false
	context.renderedHookCount = context.hookIndex
end

--————————————————————————————————————————————————————————————————————--

--- Flushes pending normal effects for a component context.
--- @param context componentContext Component context containing the effects.
function module.flushEffects(context: componentContext)
	flushEffectQueue(context, "pendingEffects")
end

--————————————————————————————————————————————————————————————————————--

--- Flushes pending layout effects for a component context.
--- @param context componentContext Component context containing the layout effects.
function module.flushLayoutEffects(context: componentContext)
	flushEffectQueue(context, "pendingLayoutEffects")
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component hook context.
--- @param requestRender (reason: string?) -> () Callback used to request another render.
--- @return componentContext Newly created component context.
function module.newContext(requestRender: (reason: string?) -> ()): componentContext
	return {
		hookIndex = 0,
		hooks = {},
		isDeleted = false,
		isRendered = false,
		needsRender = false,
		pendingEffects = {},
		pendingLayoutEffects = {},
		renderedHookCount = 0,
		requestRender = requestRender,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Synchronizes component state with a Roblox Attribute.
--- @param instance Instance Instance containing the Attribute.
--- @param attributeName string Attribute name.
--- @param defaultValue T Fallback value when the Attribute is missing.
--- @return T Current value.
--- @return (value: T) -> () Setter that updates both state and the Attribute.
function module.useAttribute<T>(instance: Instance, attributeName: string, defaultValue: T): (T, (value: T) -> ())
	local initialAttribute = instance:GetAttribute(attributeName)
	local initialValue = defaultValue
	if initialAttribute ~= nil then
		initialValue = initialAttribute :: T
	end
	local value, setValue = module.useState(initialValue)
	module.useEffect(function()
		local currentAttribute = instance:GetAttribute(attributeName)
		if currentAttribute ~= nil then
			setValue(currentAttribute :: T)
		end
		local connection = instance:GetAttributeChangedSignal(attributeName):Connect(function()
			local nextValue = instance:GetAttribute(attributeName)
			if nextValue == nil then
				return
			end
			setValue(nextValue :: T)
		end)
		return function()
			connection:Disconnect()
		end
	end, createDependencies(instance, attributeName))
	local function set(nextValue: T)
		if instance:GetAttribute(attributeName) ~= nextValue then
			instance:SetAttribute(attributeName, nextValue :: any)
		end
		setValue(nextValue)
	end
	return value, set
end

--————————————————————————————————————————————————————————————————————--

--- Creates component-owned boolean state with enable, disable, and toggle controls.
--- @param initialValue boolean? Initial value. Defaults to false.
--- @return boolean Current value.
--- @return () -> () Enable callback.
--- @return () -> () Disable callback.
--- @return () -> () Toggle callback.
function module.useBoolean(initialValue: boolean?): (boolean, () -> (), () -> (), () -> ())
	local defaultValue = initialValue or false
	local value, setValue = module.useState(defaultValue)
	local function disable()
		setValue(false)
	end
	local function enable()
		setValue(true)
	end
	local function toggle()
		setValue(function(previous: boolean): boolean
			return not previous
		end)
	end
	return value, enable, disable, toggle
end

--————————————————————————————————————————————————————————————————————--

--- Creates and owns a Reactily binding for the component lifetime.
--- @param initialValue T Initial binding value.
--- @return binding<T> Stable binding deleted automatically on unmount.
function module.useBinding<T>(initialValue: T): bindingModule.binding<T>
	local value = module.useMemo(function(): bindingModule.binding<T>
		return bindingModule.new(initialValue)
	end, {})
	module.useEffect(function()
		return function()
			value.delete()
		end
	end, createDependencies(value))
	return value
end

--————————————————————————————————————————————————————————————————————--

--- Returns a memoized callback while its dependencies remain unchanged.
--- @param callback T Callback value to preserve.
--- @param dependencies {any}? Values controlling when the callback changes.
--- @return T Stable callback value.
function module.useCallback<T>(callback: T, dependencies: dependencyList?): T
	return module.useMemo(function(): T
		return callback
	end, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Creates state that can be controlled by props or managed internally.
--- @param options controllableStateOptions<T> Controlled value, default value, and change callback.
--- @return T Current resolved value.
--- @return stateSetter<T> Setter that updates internal state when uncontrolled and always notifies onChanged.
function module.useControllableState<T>(options: controllableStateOptions<T>): (T, stateSetter<T>)
	local internalValue, setInternalValue = module.useState(options.defaultValue)
	local controlled = options.value ~= nil
	local value = internalValue
	if controlled then
		value = options.value :: T
	end
	local function setValue(nextValue: T | ((previous: T) -> T))
		local resolved = resolveStateValue(value, nextValue)
		if resolved == value then
			return
		end
		if not controlled then
			setInternalValue(resolved)
		end
		if options.onChanged then
			options.onChanged(resolved)
		end
	end
	return value, setValue
end

--————————————————————————————————————————————————————————————————————--

--- Creates component-owned numeric counter state.
--- @param initialValue number? Initial counter value. Defaults to zero.
--- @return number Current counter value.
--- @return counterControls Counter controls.
function module.useCounter(initialValue: number?): (number, counterControls)
	local defaultValue = initialValue or 0
	local value, setValue = module.useState(defaultValue)
	local controls: counterControls = {
		decrement = function(amount: number?)
			local delta = amount or 1
			setValue(function(previous: number): number
				return previous - delta
			end)
		end,
		increment = function(amount: number?)
			local delta = amount or 1
			setValue(function(previous: number): number
				return previous + delta
			end)
		end,
		reset = function()
			setValue(defaultValue)
		end,
		set = function(nextValue: number)
			setValue(nextValue)
		end,
	}
	return value, controls
end

--————————————————————————————————————————————————————————————————————--

--- Returns a delayed copy of a changing value.
--- @param value T Current value.
--- @param delaySeconds number Delay before the value updates.
--- @return T Current debounced value.
function module.useDebouncedValue<T>(value: T, delaySeconds: number): T
	assert(delaySeconds >= 0, "Reactily debounce delay must be non-negative.")
	local debounced, setDebounced = module.useState(value)
	local generation = module.useRef(0)
	module.useEffect(function()
		generation.current += 1
		local currentGeneration = generation.current
		local thread = task.delay(delaySeconds, function()
			if generation.current ~= currentGeneration then
				return
			end
			setDebounced(value)
		end)
		return function()
			if coroutine.status(thread) == "dead" then
				return
			end
			task.cancel(thread)
		end
	end, createDependencies(value, delaySeconds))
	return debounced
end

--————————————————————————————————————————————————————————————————————--

--- Returns a deferred copy of a changing value using one-shot scheduling.
--- @param value T Current value.
--- @return T Deferred value from the previous completed transition.
function module.useDeferredValue<T>(value: T): T
	local deferred, setDeferred = module.useState(value)
	module.useEffect(function()
		local thread = transitionModule.start(function()
			setDeferred(value)
		end, nil)
		return function()
			if coroutine.status(thread) == "dead" then
				return
			end
			task.cancel(thread)
		end
	end, createDependencies(value))
	return deferred
end

--————————————————————————————————————————————————————————————————————--

--- Queues an effect after the component completes rendering.
--- @param callback () -> cleanup? Effect callback with optional cleanup.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useEffect(callback: effectCallback, dependencies: dependencyList?)
	local context = getContext()
	local slot = getSlot(context, "effect")
	queueEffect(slot, callback, dependencies, context.pendingEffects)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a stable callback that always invokes the latest callback body.
--- @param callback T Current callback implementation.
--- @return T Stable callback identity.
function module.useEvent<T>(callback: T): T
	assert(type(callback) == "function", "Reactily.useEvent expects a function.")
	local latest = module.useLatest(callback)
	return module.useMemo(function(): T
		return (function(...: any)
			return (latest.current :: any)(...)
		end) :: any
	end, {})
end

--————————————————————————————————————————————————————————————————————--

--- Subscribes a component to any external store contract.
--- @param subscribe (callback: () -> ()) -> (() -> ()) Subscription factory returning cleanup.
--- @param getSnapshot () -> T Current snapshot reader.
--- @return T Current external snapshot.
function module.useExternalStore<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
	local value, setValue = module.useState(getSnapshot())
	module.useEffect(function()
		local function update()
			setValue(getSnapshot())
		end
		update()
		return subscribe(update)
	end, createDependencies(subscribe, getSnapshot))
	return value
end

--————————————————————————————————————————————————————————————————————--

--- Returns focus state for a GuiObject.
--- @param object GuiObject GUI object to observe.
--- @return boolean Whether the object currently owns selection focus.
function module.useFocus(object: GuiObject): boolean
	local focused, setFocused = module.useState(false)
	module.useEffect(function()
		local gained = object.SelectionGained:Connect(function()
			setFocused(true)
		end)
		local lost = object.SelectionLost:Connect(function()
			setFocused(false)
		end)
		return function()
			gained:Disconnect()
			lost:Disconnect()
		end
	end, createDependencies(object))
	return focused
end

--————————————————————————————————————————————————————————————————————--

--- Returns hover state for a GuiObject.
--- @param object GuiObject GUI object to observe.
--- @return boolean Whether the pointer is currently hovering the object.
function module.useHover(object: GuiObject): boolean
	local hovered, setHovered = module.useState(false)
	module.useEffect(function()
		local entered = object.MouseEnter:Connect(function()
			setHovered(true)
		end)
		local left = object.MouseLeave:Connect(function()
			setHovered(false)
		end)
		return function()
			entered:Disconnect()
			left:Disconnect()
		end
	end, createDependencies(object))
	return hovered
end

--————————————————————————————————————————————————————————————————————--

--- Creates or updates an imperative handle exposed through a Reactily ref.
--- @param target refTarget<T>? Target ref object or callback.
--- @param factory () -> T Factory producing the exposed handle.
--- @param dependencies {any}? Values controlling when the handle is recreated.
function module.useImperativeHandle<T>(target: refTarget<T>?, factory: () -> T, dependencies: dependencyList?)
	module.useLayoutEffect(function()
		local value = factory()
		setRefTarget(target, value)
		return function()
			setRefTarget(target, nil)
		end
	end, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a stable component-local identifier.
--- @return string Stable Reactily identifier.
function module.useId(): string
	return module.useMemo(function(): string
		nextHookId += 1
		return `reactily-{nextHookId}`
	end, {})
end

--————————————————————————————————————————————————————————————————————--

--- Queues an effect for the layout phase before normal effects.
--- @param callback () -> cleanup? Layout effect callback.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useLayoutEffect(callback: effectCallback, dependencies: dependencyList?)
	local context = getContext()
	local slot = getSlot(context, "layoutEffect")
	queueEffect(slot, callback, dependencies, context.pendingLayoutEffects)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a stable ref whose current field is refreshed every render.
--- @param value T Current value.
--- @return ref<T> Stable latest-value ref.
function module.useLatest<T>(value: T): ref<T>
	local latest = module.useRef(value)
	latest.current = value
	return latest
end

--————————————————————————————————————————————————————————————————————--

--- Runs an effect once when the component mounts.
--- @param callback () -> cleanup? Mount callback with optional cleanup.
function module.useMount(callback: effectCallback)
	module.useEffect(callback, {})
end

--————————————————————————————————————————————————————————————————————--

--- Memoizes a value while its dependencies remain unchanged.
--- @param factory () -> T Factory used to create the value.
--- @param dependencies {any}? Values controlling when the value is recalculated.
--- @return T Memoized value.
function module.useMemo<T>(factory: () -> T, dependencies: dependencyList?): T
	local context = getContext()
	local slot = getSlot(context, "memo")
	local shouldResolve = not slot.isInitialized
	if slot.isInitialized then
		shouldResolve = dependenciesChanged(slot.dependencies, dependencies)
	end
	if shouldResolve then
		slot.isInitialized = true
		slot.value = factory()
		slot.dependencies = nil
		if dependencies then
			slot.dependencies = table.clone(dependencies)
		end
	end
	return slot.value :: T
end

--————————————————————————————————————————————————————————————————————--

--- Registers a delete-capable object for automatic component cleanup.
--- @param value T Object exposing a dot-call delete() method.
--- @return T Same object for fluent ownership setup.
function module.useOwned<T>(value: T): T
	module.useEffect(function()
		return function()
			local candidate = value :: any
			if typeof(candidate) == "RBXScriptConnection" then
				if candidate.Connected then
					candidate:Disconnect()
				end
				return
			end
			if type(candidate) == "thread" then
				if coroutine.status(candidate) ~= "dead" then
					task.cancel(candidate)
				end
				return
			end
			if type(candidate) == "function" then
				candidate()
				return
			end
			if type(candidate) ~= "table" then
				return
			end
			if type(candidate.delete) == "function" then
				candidate.delete()
				return
			end
			if type(candidate.disconnect) == "function" then
				candidate.disconnect()
				return
			end
			if type(candidate.cancel) == "function" then
				candidate.cancel()
			end
		end
	end, createDependencies(value))
	return value
end

--————————————————————————————————————————————————————————————————————--

--- Returns pressed state for a GuiButton or GuiObject input surface.
--- @param object GuiObject GUI object to observe.
--- @return boolean Whether a primary pointer press is active.
function module.usePressed(object: GuiObject): boolean
	local pressed, setPressed = module.useState(false)
	module.useEffect(function()
		local began = object.InputBegan:Connect(function(input: InputObject)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end
			setPressed(true)
		end)
		local ended = object.InputEnded:Connect(function(input: InputObject)
			if
				input.UserInputType ~= Enum.UserInputType.MouseButton1
				and input.UserInputType ~= Enum.UserInputType.Touch
			then
				return
			end
			setPressed(false)
		end)
		return function()
			began:Disconnect()
			ended:Disconnect()
		end
	end, createDependencies(object))
	return pressed
end

--————————————————————————————————————————————————————————————————————--

--- Returns the value from the previous completed render.
--- @param value T Current value.
--- @param initialValue T? Optional value returned before a previous render exists.
--- @return T? Previous value or initialValue.
function module.usePrevious<T>(value: T, initialValue: T?): T?
	local context = getContext()
	local slot = getSlot(context, "previous")
	local previous = initialValue
	if slot.isInitialized then
		previous = slot.value :: T
	end
	slot.isInitialized = true
	slot.value = value
	return previous
end

--————————————————————————————————————————————————————————————————————--

--- Creates reducer-driven component state.
--- @param reducer (stateValue: S, action: A) -> S Reducer used to resolve the next state.
--- @param initialState S Initial reducer state.
--- @return S Current state.
--- @return reducerDispatch<A> Dispatch function.
function module.useReducer<S, A>(reducer: (stateValue: S, action: A) -> S, initialState: S): (S, reducerDispatch<A>)
	local context = getContext()
	local slot = getSlot(context, "reducer")
	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = initialState
		slot.callback = function(action: A)
			if context.isDeleted then
				return
			end
			devMode.warnIf(currentContext ~= nil, "Reactily reducer dispatch occurred during component rendering.")
			local previous = slot.value :: S
			local nextValue = reducer(previous, action)
			if previous == nextValue then
				return
			end
			slot.value = nextValue
			context.needsRender = true
			context.requestRender("reducer changed")
		end
	end
	return slot.value :: S, slot.callback :: reducerDispatch<A>
end

--————————————————————————————————————————————————————————————————————--

--- Creates a mutable ref that persists across component renders.
--- @param initialValue T Initial ref value.
--- @return ref<T> Stable mutable ref.
function module.useRef<T>(initialValue: T): ref<T>
	local context = getContext()
	local slot = getSlot(context, "ref")
	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = {
			current = initialValue,
		}
	end
	return slot.value :: ref<T>
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component-owned spring and updates its target when the input changes.
--- @param target T Desired spring target.
--- @param options springOptions? Spring configuration.
--- @return spring<T> Stable spring controller.
function module.useSpring<T>(target: T, options: springModule.springOptions?): springModule.spring<T>
	local springValue = module.useMemo(function(): springModule.spring<T>
		return springModule.new(target, options)
	end, {})
	module.useEffect(function()
		springValue.setTarget(target)
	end, createDependencies(target))
	module.useEffect(function()
		return function()
			springValue.delete()
		end
	end, createDependencies(springValue))
	return springValue
end

--————————————————————————————————————————————————————————————————————--

--- Creates component-owned state.
--- @param initialValue T Initial state value.
--- @return T Current state value.
--- @return stateSetter<T> Setter for updating the state.
function module.useState<T>(initialValue: T): (T, stateSetter<T>)
	local context = getContext()
	local slot = getSlot(context, "state")
	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = initialValue
		slot.callback = function(nextValue: T | ((previous: T) -> T))
			if context.isDeleted then
				return
			end
			devMode.warnIf(currentContext ~= nil, "Reactily state update occurred during component rendering.")
			local previous = slot.value :: T
			local resolved = resolveStateValue(previous, nextValue)
			if previous == resolved then
				return
			end
			slot.value = resolved
			context.needsRender = true
			context.requestRender("state changed")
		end
	end
	return slot.value :: T, slot.callback :: stateSetter<T>
end

--————————————————————————————————————————————————————————————————————--

--- Subscribes a component to a Reactily store, optionally selecting one derived value.
--- @param storeValue store<S> Source store.
--- @param selectorFunction ((state: S) -> R)? Optional selector. Without one, the full state is returned.
--- @return any Current selected value.
function module.useStore<S>(storeValue: storeModule.store<S>, selectorFunction: ((state: S) -> any)?): any
	local function selectValue(): any
		local state = storeValue.get()
		if not selectorFunction then
			return state
		end
		return selectorFunction(state)
	end
	local value, setValue = module.useState(selectValue())
	module.useEffect(function()
		setValue(selectValue())
		local connection = storeValue.subscribe(function()
			setValue(selectValue())
		end)
		return function()
			connection.disconnect()
		end
	end, createDependencies(storeValue, selectorFunction))
	return value
end

--————————————————————————————————————————————————————————————————————--

--- Creates and owns a TweenService animation while dependencies remain current.
--- @param instance Instance Instance to animate.
--- @param goals {[string]: any} Target property values.
--- @param options tweenOptions Tween settings.
--- @param dependencies {any}? Values controlling when the tween restarts.
--- @return animation? Most recently created animation after the layout effect runs.
function module.useTween(
	instance: Instance,
	goals: { [string]: any },
	options: animationModule.tweenOptions,
	dependencies: dependencyList?
): animationModule.animation?
	local animationRef = module.useRef(nil :: animationModule.animation?)
	module.useLayoutEffect(function()
		if animationRef.current then
			animationRef.current.delete()
		end
		local animationValue = animationModule.play(instance, goals, options)
		animationRef.current = animationValue
		return function()
			if animationRef.current ~= animationValue then
				return
			end
			animationValue.delete()
			animationRef.current = nil
		end
	end, dependencies)
	return animationRef.current
end

--————————————————————————————————————————————————————————————————————--

--- Creates component-owned boolean toggle state.
--- @param initialValue boolean? Initial value. Defaults to false.
--- @return boolean Current value.
--- @return () -> () Toggle callback.
--- @return (value: boolean) -> () Setter for assigning the value.
function module.useToggle(initialValue: boolean?): (boolean, () -> (), (value: boolean) -> ())
	local value, enable, disable, toggle = module.useBoolean(initialValue)
	local function set(nextValue: boolean)
		if nextValue then
			enable()
			return
		end
		disable()
	end
	return value, toggle, set
end

--————————————————————————————————————————————————————————————————————--

--- Creates a low-priority transition starter and pending state.
--- @return boolean Whether one or more transitions are pending.
--- @return transitionStarter Function used to start transition work.
function module.useTransition(): (boolean, transitionStarter)
	local pending, setPending = module.useState(false)
	local pendingCount = module.useRef(0)
	local function start(callback: () -> ())
		pendingCount.current += 1
		setPending(true)
		transitionModule.start(callback, function()
			pendingCount.current = math.max(pendingCount.current - 1, 0)
			if pendingCount.current > 0 then
				return
			end
			setPending(false)
		end)
	end
	return pending, start
end

--————————————————————————————————————————————————————————————————————--

--- Runs an effect only after the initial completed render.
--- @param callback () -> cleanup? Update effect callback.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useUpdateEffect(callback: effectCallback, dependencies: dependencyList?)
	local mounted = module.useRef(false)
	module.useEffect(function()
		if not mounted.current then
			mounted.current = true
			return nil
		end
		return (callback :: any)()
	end, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Registers cleanup that runs only when the component unmounts.
--- @param callback () -> () Unmount callback.
function module.useUnmount(callback: () -> ())
	local latest = module.useLatest(callback)
	module.useEffect(function()
		return function()
			latest.current()
		end
	end, {})
end

--————————————————————————————————————————————————————————————————————--

--- Reads the current value from a Reactily context.
--- @param contextValue context<T> Context returned by Reactily.createContext.
--- @return T Current provider value or the context default.
function module.useContext<T>(contextValue: contextModule.context<T>): T
	getContext()
	return contextModule.get(contextValue)
end

--————————————————————————————————————————————————————————————————————--

return module
