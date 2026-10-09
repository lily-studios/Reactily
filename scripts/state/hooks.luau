--[[
   Reactily · Lily Studios

   Copyright (c) Lily Studios and contributors.
   Licensed under the MIT License.
   See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local collectionService = game:GetService("CollectionService")
local guiService = game:GetService("GuiService")
local players = game:GetService("Players")
local workspaceService = game:GetService("Workspace")

--————————————————————————————————————————————————————————————————————--

local animationModule = require(script.Parent.Parent.runtime.animation)
local bindingModule = require(script.Parent.Parent.runtime.binding)
local contextModule = require(script.Parent.context)
local devMode = require(script.Parent.Parent.core.devMode)
local deviceModule = require(script.Parent.Parent.interface.device)
local shortcutModule = require(script.Parent.Parent.interface.shortcut)
local springModule = require(script.Parent.Parent.runtime.spring)
local storeModule = require(script.Parent.store)
local transitionModule = require(script.Parent.Parent.runtime.transition)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- Function called to release a hook-owned resource.
type Cleanup = () -> ()
--- Values compared between renders to determine whether work should rerun.
type DependencyList = { any }
--- Effect callback that may return a cleanup function.
type EffectCallback = (() -> ()) | (() -> Cleanup?)

--- Persistent storage for one hook invocation in a component.
--- @field callback any Latest registered callback or state setter.
--- @field cleanup cleanup? Cleanup associated with the last executed effect.
--- @field dependencies dependencyList? Last recorded dependencies.
--- @field isInitialized boolean Whether this slot has been initialized.
--- @field kind string Hook type, used to validate call order.
--- @field value any State, memo value, or ref held by the slot.
type HookSlot = {
	callback: any,
	cleanup: Cleanup?,
	dependencies: DependencyList?,
	isInitialized: boolean,
	kind: string,
	value: any,
}

--- Effect scheduled for an insertion, layout, or normal effect phase.
--- @field callback effectCallback Effect to execute.
--- @field slot hookSlot Slot receiving the resulting cleanup.
type PendingEffect = {
	callback: EffectCallback,
	slot: HookSlot,
}

--- Saved hook state used to roll back a failed component render.
--- @field callback any Callback saved before rendering.
--- @field cleanup cleanup? Prior cleanup function.
--- @field dependencies dependencyList? Prior dependency values.
--- @field isInitialized boolean Prior initialization status.
--- @field slot hookSlot Original slot being restored.
--- @field value any Value saved before rendering.
type HookSnapshot = {
	callback: any,
	cleanup: Cleanup?,
	dependencies: DependencyList?,
	isInitialized: boolean,
	slot: HookSlot,
	value: any,
}

--- Lifecycle and hook storage owned by one mounted component.
--- @field hookIndex number Index of the hook currently being evaluated.
--- @field hooks {hookSlot} Hooks preserved between renders.
--- @field isDeleted boolean Whether the component context has been deleted.
--- @field isEffectsPaused boolean Whether effects are currently paused.
--- @field isRendered boolean Whether a render completed successfully.
--- @field needsRender boolean Whether a state update requires another render.
--- @field pendingEffects {pendingEffect} Effects queued for the normal phase.
--- @field pendingInsertionEffects {pendingEffect} Effects queued for the insertion phase.
--- @field pendingLayoutEffects {pendingEffect} Effects queued for the layout phase.
--- @field renderedHookCount number Hook count from the last completed render.
--- @field requestRender function Callback for requesting another root render.
export type ComponentContext = {
	hookIndex: number,
	hooks: { HookSlot },
	isDeleted: boolean,
	isEffectsPaused: boolean,
	isRendered: boolean,
	needsRender: boolean,
	pendingEffects: { PendingEffect },
	pendingInsertionEffects: { PendingEffect },
	pendingLayoutEffects: { PendingEffect },
	renderedHookCount: number,
	requestRender: (reason: string?) -> (),
}

--- Options for state that supports controlled and uncontrolled usage.
--- @field defaultValue T Starting value for internally owned state.
--- @field onChanged function? Optional callback invoked after a value change.
--- @field value T? Controlled value, when supplied.
export type ControllableStateOptions<T> = {
	defaultValue: T,
	onChanged: ((value: T) -> ())?,
	value: T?,
}

--- Callbacks returned by useCounter for manipulating the current count.
--- @field decrement function Decreases the count by an optional amount.
--- @field increment function Increases the count by an optional amount.
--- @field reset function Restores the initial count.
--- @field set function Assigns the count to the supplied number.
export type CounterControls = {
	decrement: (amount: number?) -> (),
	increment: (amount: number?) -> (),
	reset: () -> (),
	set: (value: number) -> (),
}
--- Dispatch callback used by reducer-driven state.
export type ReducerDispatch<A> = (action: A) -> ()
--- Mutable reference whose current value persists across renders.
export type Ref<T> = { current: T }

--- Object ref or callback ref that accepts an optional value.
export type RefTarget<T> = Ref<T?> | ((value: T?) -> ())
--- Setter accepting a direct value or updater function.
export type StateSetter<T> = (value: T | ((previous: T) -> T)) -> ()
--- Function used to start a transition action.
export type TransitionStarter = (callback: () -> ()) -> ()

--————————————————————————————————————————————————————————————————————--

local currentContext: ComponentContext? = nil
local nextHookId = 0
local renderSnapshots: { [ComponentContext]: { HookSnapshot } } = {}

do
	local weakRenderSnapshots: any = renderSnapshots

	setmetatable(weakRenderSnapshots, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Creates a mutable React-style ref for Roblox Instances or other values.
--- @return ref<T?> Mutable ref whose current value starts as nil.
function module.createRef<T>(): Ref<T?>
	return {
		current = nil,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a dependency array from the supplied values.
--- @param ... any Values to store as dependencies.
--- @return dependencyList Captured dependencies in argument order.
local function createDependencies(...: any): DependencyList
	return { ... }
end

--————————————————————————————————————————————————————————————————————--

--- Checks whether two dependency arrays differ by length or value.
--- @param previous dependencyList? Dependencies from the previous render.
--- @param current dependencyList? Dependencies supplied by the current render.
--- @return boolean Whether the effect or memo should update.
local function dependenciesChanged(previous: DependencyList?, current: DependencyList?): boolean
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

--- Returns the component context currently rendering and verifies it is valid.
--- @return componentContext Active component context.
local function getContext(): ComponentContext
	local context = currentContext
	assert(context, "Reactily hook called outside a component render.")
	assert(not context.isDeleted, "Reactily component context is deleted.")
	return context
end

--————————————————————————————————————————————————————————————————————--

--- Retrieves or creates the next hook slot in render order.
--- @param context componentContext Context that owns the hook slot.
--- @param kind string Hook kind used to enforce consistent hook ordering.
--- @return hookSlot Existing or newly allocated hook slot.
local function getSlot(context: ComponentContext, kind: string): HookSlot
	context.hookIndex += 1
	local existingSlot = context.hooks[context.hookIndex]
	if existingSlot then
		assert(existingSlot.kind == kind, `Reactily hook order changed from "{existingSlot.kind}" to "{kind}".`)
		return existingSlot
	end
	local slot: HookSlot = {
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

--- Executes an effect cleanup and reports failures without interrupting cleanup.
--- @param callback cleanup Cleanup function to execute.
local function runCleanup(callback: Cleanup)
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

--- Resolves a direct state value or updater function against previous state.
--- @param previous T Previous state value.
--- @param nextValue T | function Replacement value or functional updater.
--- @return T Resolved next state value.
local function resolveStateValue<T>(previous: T, nextValue: T | ((previous: T) -> T)): T
	if type(nextValue) == "function" then
		return (nextValue :: (previous: T) -> T)(previous)
	end
	return nextValue :: T
end

--————————————————————————————————————————————————————————————————————--

--- Schedules an effect when its dependencies have changed.
--- @param slot hookSlot Slot containing the effect lifecycle state.
--- @param callback effectCallback Effect callback to execute.
--- @param dependencies dependencyList? Dependency values for the effect.
--- @param queue {pendingEffect} Pending-effect queue to append to.
local function queueEffect(
	slot: HookSlot,
	callback: EffectCallback,
	dependencies: DependencyList?,
	queue: { PendingEffect }
)
	if slot.isInitialized and not dependenciesChanged(slot.dependencies, dependencies) then
		return
	end
	slot.isInitialized = true
	slot.callback = callback
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

--- Runs queued effects and replaces their existing cleanup functions.
--- @param context componentContext Component context owning the effects.
--- @param queueName string Name of the effect queue to flush.
local function flushEffectQueue(
	context: ComponentContext,
	queueName: "PendingEffects" | "PendingInsertionEffects" | "PendingLayoutEffects"
)
	if context.isDeleted or context.isEffectsPaused then
		return
	end
	local queue: { PendingEffect }
	if queueName == "PendingEffects" then
		queue = context.pendingEffects
		context.pendingEffects = {}
	elseif queueName == "PendingInsertionEffects" then
		queue = context.pendingInsertionEffects
		context.pendingInsertionEffects = {}
	else
		queue = context.pendingLayoutEffects
		context.pendingLayoutEffects = {}
	end

	if #queue == 0 then
		return
	end
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
			effect.slot.cleanup = cleanupValue :: Cleanup?
			continue
		end
		warn(`Reactily effect failed: {failure}`)
	end
	table.clear(queue)
end

--————————————————————————————————————————————————————————————————————--

--- Assigns an imperative value to an object ref or callback ref.
--- @param target refTarget<T>? Ref receiving the value, when provided.
--- @param value T? Value to expose, or nil when releasing the ref.
local function setRefTarget<T>(target: RefTarget<T>?, value: T?)
	if not target then
		return
	end
	if type(target) == "function" then
		(target :: (T?) -> ())(value)
		return
	end
	(target :: Ref<T?>).current = value
end

--————————————————————————————————————————————————————————————————————--

--- Begins a component render using the provided hook context.
--- @param context componentContext Component context entering the render phase.
function module.beginRender(context: ComponentContext)
	assert(not context.isDeleted, "Reactily component context is deleted.")
	assert(currentContext == nil, "Reactily component renders cannot overlap.")

	local snapshot: { HookSnapshot } = table.create(#context.hooks)
	for _, slot in context.hooks do
		local dependencies: DependencyList? = nil
		if slot.dependencies then
			dependencies = table.clone(slot.dependencies)
		end

		snapshot[#snapshot + 1] = {
			callback = slot.callback,
			cleanup = slot.cleanup,
			dependencies = dependencies,
			isInitialized = slot.isInitialized,
			slot = slot,
			value = slot.value,
		}
	end

	context.hookIndex = 0
	renderSnapshots[context] = snapshot
	currentContext = context
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a component context and releases its owned hook resources.
--- @param context componentContext Component context to delete.
--- @return boolean Whether the context was deleted.
function module.deleteContext(context: ComponentContext): boolean
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
	table.clear(context.pendingInsertionEffects)
	table.clear(context.pendingLayoutEffects)
	renderSnapshots[context] = nil
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Completes the active component render.
--- @param context componentContext Component context completing the render.
--- @param didComplete boolean Whether the render completed successfully.
function module.endRender(context: ComponentContext, didComplete: boolean)
	assert(currentContext == context, "Reactily render context does not match the active component.")
	currentContext = nil

	local snapshot = renderSnapshots[context]

	--- Restores saved hook slots and removes effects after an unsuccessful render.
	local function rollback()
		table.clear(context.pendingEffects)
		table.clear(context.pendingInsertionEffects)
		table.clear(context.pendingLayoutEffects)

		if not context.isRendered then
			table.clear(context.hooks)
			return
		end

		if snapshot then
			for _, saved in snapshot do
				local slot = saved.slot
				slot.callback = saved.callback
				slot.cleanup = saved.cleanup
				slot.dependencies = saved.dependencies
				slot.isInitialized = saved.isInitialized
				slot.value = saved.value
			end
		end

		for index = #context.hooks, context.renderedHookCount + 1, -1 do
			table.remove(context.hooks, index)
		end
	end

	if not didComplete then
		rollback()
		renderSnapshots[context] = nil
		return
	end

	if context.isRendered and context.hookIndex ~= context.renderedHookCount then
		rollback()
		renderSnapshots[context] = nil
		error("Reactily hook count changed between renders.", 2)
	end

	renderSnapshots[context] = nil
	context.isRendered = true
	context.needsRender = false
	context.renderedHookCount = context.hookIndex
end

--————————————————————————————————————————————————————————————————————--

--- Flushes pending normal effects for a component context.
--- @param context componentContext Component context containing the effects.
function module.flushEffects(context: ComponentContext)
	flushEffectQueue(context, "PendingEffects")
end

--————————————————————————————————————————————————————————————————————--

--- Flushes pending insertion effects for a component context.
--- Insertion effects run after host mutation and before layout effects.
--- @param context componentContext Component context containing insertion effects.
function module.flushInsertionEffects(context: ComponentContext)
	flushEffectQueue(context, "PendingInsertionEffects")
end

--————————————————————————————————————————————————————————————————————--

--- Flushes pending layout effects for a component context.
--- @param context componentContext Component context containing the layout effects.
function module.flushLayoutEffects(context: ComponentContext)
	flushEffectQueue(context, "PendingLayoutEffects")
end

--————————————————————————————————————————————————————————————————————--

--- Requeues a previously initialized effect when a subtree becomes visible.
--- @param context componentContext Context receiving the queued effect.
--- @param slot hookSlot Initialized effect slot to requeue.
local function enqueueStoredEffect(context: ComponentContext, slot: HookSlot)
	if not slot.isInitialized or type(slot.callback) ~= "function" then
		return
	end

	local pending: PendingEffect = {
		callback = slot.callback :: EffectCallback,
		slot = slot,
	}

	if slot.kind == "insertionEffect" then
		context.pendingInsertionEffects[#context.pendingInsertionEffects + 1] = pending
	elseif slot.kind == "layoutEffect" then
		context.pendingLayoutEffects[#context.pendingLayoutEffects + 1] = pending
	elseif slot.kind == "effect" then
		context.pendingEffects[#context.pendingEffects + 1] = pending
	end
end

--- Pauses component effects while preserving hook state.
--- Existing cleanups run exactly once and pending effects are held until resume.
--- @param context componentContext Component context whose effects should pause.
function module.pauseEffects(context: ComponentContext)
	if context.isDeleted or context.isEffectsPaused then
		return
	end

	context.isEffectsPaused = true
	table.clear(context.pendingEffects)
	table.clear(context.pendingInsertionEffects)
	table.clear(context.pendingLayoutEffects)

	for _, slot in context.hooks do
		if slot.kind ~= "effect" and slot.kind ~= "layoutEffect" and slot.kind ~= "insertionEffect" then
			continue
		end
		if slot.cleanup then
			runCleanup(slot.cleanup)
			slot.cleanup = nil
		end
	end
end

--- Resumes a paused component and reruns its active effects in lifecycle order.
--- @param context componentContext Component context whose effects should resume.
function module.resumeEffects(context: ComponentContext)
	if context.isDeleted or not context.isEffectsPaused then
		return
	end

	context.isEffectsPaused = false
	for _, slot in context.hooks do
		enqueueStoredEffect(context, slot)
	end
	module.flushInsertionEffects(context)
	module.flushLayoutEffects(context)
	module.flushEffects(context)
end

--- Replays active effects for StrictMode development checks.
--- @param context componentContext Component context whose effects should replay.
function module.replayEffects(context: ComponentContext)
	if context.isDeleted or context.isEffectsPaused then
		return
	end
	module.pauseEffects(context)
	module.resumeEffects(context)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component hook context.
--- @param requestRender (reason: string?) -> () Callback used to request another render.
--- @return componentContext Newly created component context.
function module.newContext(requestRender: (reason: string?) -> ()): ComponentContext
	return {
		hookIndex = 0,
		hooks = {},
		isDeleted = false,
		isEffectsPaused = false,
		isRendered = false,
		needsRender = false,
		pendingEffects = {},
		pendingInsertionEffects = {},
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
		if currentAttribute == nil then
			setValue(defaultValue)
		else
			setValue(currentAttribute :: T)
		end

		local connection = instance:GetAttributeChangedSignal(attributeName):Connect(function()
			local nextValue = instance:GetAttribute(attributeName)
			if nextValue == nil then
				setValue(defaultValue)
				return
			end
			setValue(nextValue :: T)
		end)
		return function()
			connection:Disconnect()
		end
	end, createDependencies(instance, attributeName, defaultValue))
	--- Writes a new Attribute value and synchronizes component state.
	--- @param nextValue T Value to store in the Roblox Attribute.
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
	--- Sets the boolean hook state to false.
	local function disable()
		setValue(false)
	end
	--- Sets the boolean hook state to true.
	local function enable()
		setValue(true)
	end
	--- Inverts the current boolean hook state.
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
function module.useBinding<T>(initialValue: T): bindingModule.Binding<T>
	local value = module.useMemo(function(): bindingModule.Binding<T>
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
function module.useCallback<T>(callback: T, dependencies: DependencyList?): T
	return module.useMemo(function(): T
		return callback
	end, dependencies)
end

--————————————————————————————————————————————————————————————————————--

--- Creates state that can be controlled by props or managed internally.
--- @param options controllableStateOptions<T> Controlled value, default value, and change callback.
--- @return T Current resolved value.
--- @return stateSetter<T> Setter that updates internal state when uncontrolled and always notifies onChanged.
function module.useControllableState<T>(options: ControllableStateOptions<T>): (T, StateSetter<T>)
	local internalValue, setInternalValue = module.useState(options.defaultValue)
	local controlled = options.value ~= nil
	local value = internalValue
	if controlled then
		value = options.value :: T
	end
	--- Applies a controlled or uncontrolled state update.
	--- @param nextValue T | function Direct value or updater function.
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
function module.useCounter(initialValue: number?): (number, CounterControls)
	local defaultValue = initialValue or 0
	local value, setValue = module.useState(defaultValue)
	local controls: CounterControls = {
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
	local generation = module.useRef(0)

	module.useEffect(function()
		generation.current += 1
		local currentGeneration = generation.current

		transitionModule.start(function()
			if generation.current ~= currentGeneration then
				return
			end
			setDeferred(value)
		end, nil)

		return nil
	end, createDependencies(value))

	return deferred
end

--————————————————————————————————————————————————————————————————————--

--- Queues an effect after the component completes rendering.
--- @param callback () -> cleanup? Effect callback with optional cleanup.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useEffect(callback: EffectCallback, dependencies: DependencyList?)
	local context = getContext()
	local slot = getSlot(context, "effect")
	queueEffect(slot, callback, dependencies, context.pendingEffects)
end

--————————————————————————————————————————————————————————————————————--

--- Queues an insertion effect after host mutations and before layout effects.
--- Use this for framework-level host registration rather than ordinary UI side effects.
--- @param callback () -> cleanup? Insertion callback with optional cleanup.
--- @param dependencies {any}? Values controlling when the effect reruns.
function module.useInsertionEffect(callback: EffectCallback, dependencies: DependencyList?)
	local context = getContext()
	local slot = getSlot(context, "insertionEffect")
	queueEffect(slot, callback, dependencies, context.pendingInsertionEffects)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a stable callback that always invokes the latest callback body.
--- @param callback T Current callback implementation.
--- @return T Stable callback identity.
local function useStableEvent<T>(callback: T): T
	assert(type(callback) == "function", "Reactily effect-event callback must be a function.")
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
local function useExternalSnapshot<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
	local value, setValue = module.useState(getSnapshot())
	module.useEffect(function()
		--- Reads the current external snapshot into component state.
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
	local focused, setFocused = module.useState(guiService.SelectedObject == object)
	module.useEffect(function()
		setFocused(guiService.SelectedObject == object)
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
function module.useImperativeHandle<T>(target: RefTarget<T>?, factory: () -> T, dependencies: DependencyList?)
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
function module.useLayoutEffect(callback: EffectCallback, dependencies: DependencyList?)
	local context = getContext()
	local slot = getSlot(context, "layoutEffect")
	queueEffect(slot, callback, dependencies, context.pendingLayoutEffects)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a stable ref whose current field is refreshed every render.
--- @param value T Current value.
--- @return ref<T> Stable latest-value ref.
function module.useLatest<T>(value: T): Ref<T>
	local latest = module.useRef(value)
	latest.current = value
	return latest
end

--————————————————————————————————————————————————————————————————————--

--- Runs an effect once when the component mounts.
--- @param callback () -> cleanup? Mount callback with optional cleanup.
function module.useMount(callback: EffectCallback)
	module.useEffect(callback, {})
end

--————————————————————————————————————————————————————————————————————--

--- Memoizes a value while its dependencies remain unchanged.
--- @param factory () -> T Factory used to create the value.
--- @param dependencies {any}? Values controlling when the value is recalculated.
--- @return T Memoized value.
function module.useMemo<T>(factory: () -> T, dependencies: DependencyList?): T
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
function module.useReducer<S, A>(reducer: (stateValue: S, action: A) -> S, initialState: S): (S, ReducerDispatch<A>)
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
	return slot.value :: S, slot.callback :: ReducerDispatch<A>
end

--————————————————————————————————————————————————————————————————————--

--- Creates a mutable ref that persists across component renders.
--- @param initialValue T Initial ref value.
--- @return ref<T> Stable mutable ref.
function module.useRef<T>(initialValue: T): Ref<T>
	local context = getContext()
	local slot = getSlot(context, "ref")
	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = {
			current = initialValue,
		}
	end
	return slot.value :: Ref<T>
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component-owned spring and updates its target when the input changes.
--- @param target T Desired spring target.
--- @param options springOptions? Spring configuration.
--- @return spring<T> Stable spring controller.
function module.useSpring<T>(target: T, options: springModule.SpringOptions?): springModule.Spring<T>
	local springValue = module.useMemo(function(): springModule.Spring<T>
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
function module.useState<T>(initialValue: T): (T, StateSetter<T>)
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
	return slot.value :: T, slot.callback :: StateSetter<T>
end

--————————————————————————————————————————————————————————————————————--

--- Subscribes a component to a Reactily store, optionally selecting one derived value.
--- @param storeValue store<S> Source store.
--- @param selectorFunction ((state: S) -> R)? Optional selector. Without one, the full state is returned.
--- @return any Current selected value.
function module.useStore<S>(storeValue: storeModule.Store<S>, selectorFunction: ((state: S) -> any)?): any
	--- Reads the store state and applies the optional selector.
	--- @return any Selected store value or the full state.
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
	options: animationModule.TweenOptions,
	dependencies: DependencyList?
): animationModule.Animation?
	local animationRef = module.useRef(nil :: animationModule.Animation?)
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
	--- Assigns boolean state using enable and disable controls.
	--- @param nextValue boolean Desired toggle state.
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
function module.useTransition(): (boolean, TransitionStarter)
	local pending, setPending = module.useState(false)
	local pendingCount = module.useRef(0)
	--- Begins tracked low-priority transition work for the component.
	--- @param callback () -> () Transition action to execute.
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
function module.useUpdateEffect(callback: EffectCallback, dependencies: DependencyList?)
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
function module.useContext<T>(contextValue: contextModule.Context<T>): T
	getContext()
	return contextModule.get(contextValue)
end

--————————————————————————————————————————————————————————————————————--

--- Stores a development-only debug value in the current hook slot.
--- @param value T Debug value.
--- @param formatter ((value: T) -> any)? Optional formatter.
function module.useDebugValue<T>(value: T, formatter: ((value: T) -> any)?)
	local context = getContext()
	local slot = getSlot(context, "debugValue")
	slot.isInitialized = true

	if formatter then
		slot.value = formatter(value)
		return
	end

	slot.value = value
end

--————————————————————————————————————————————————————————————————————--

--- Returns the current Roblox camera and updates when Workspace.CurrentCamera changes.
--- @return Camera? Current camera.
function module.useCurrentCamera(): Camera?
	local camera, setCamera = module.useState(workspaceService.CurrentCamera)

	module.useEffect(function()
		local connection = workspaceService:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			setCamera(workspaceService.CurrentCamera)
		end)

		return function()
			connection:Disconnect()
		end
	end, {})

	return camera
end

--————————————————————————————————————————————————————————————————————--

--- Returns reactive Roblox device and viewport information.
--- @return deviceState Current device state.
function module.useDevice(): deviceModule.DeviceState
	local monitor = module.useMemo(function(): deviceModule.DeviceMonitor
		return deviceModule.create()
	end, {})
	local value, setValue = module.useState(monitor.get())

	module.useEffect(function()
		local connection = monitor.subscribe(function(nextValue: deviceModule.DeviceState)
			setValue(nextValue)
		end)

		return function()
			connection.disconnect()
			monitor.delete()
		end
	end, createDependencies(monitor))

	return value
end

--————————————————————————————————————————————————————————————————————--

--- Returns the local Roblox Player when available.
--- @return Player? Local player.
function module.useLocalPlayer(): Player?
	return players.LocalPlayer
end

--————————————————————————————————————————————————————————————————————--

--- Observes AbsolutePosition and AbsoluteSize for a GuiObject.
--- @param object GuiObject Object to measure.
--- @return {AbsolutePosition: Vector2, AbsoluteSize: Vector2} Current bounds.
function module.useMeasure(object: GuiObject): { AbsolutePosition: Vector2, AbsoluteSize: Vector2 }
	local value, setValue = module.useState({
		AbsolutePosition = object.AbsolutePosition,
		AbsoluteSize = object.AbsoluteSize,
	})

	module.useEffect(function()
		--- Refreshes the GUI object's measured position and size.
		local function update()
			local nextValue = {
				AbsolutePosition = object.AbsolutePosition,
				AbsoluteSize = object.AbsoluteSize,
			}

			setValue(function(previous)
				if
					previous.AbsolutePosition == nextValue.AbsolutePosition
					and previous.AbsoluteSize == nextValue.AbsoluteSize
				then
					return previous
				end

				return nextValue
			end)
		end

		local positionConnection = object:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
		local sizeConnection = object:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

		return function()
			positionConnection:Disconnect()
			sizeConnection:Disconnect()
		end
	end, createDependencies(object))

	return value
end

--————————————————————————————————————————————————————————————————————--

--- Creates React-style optimistic state that synchronizes back to the supplied base value.
--- @param value T Base value.
--- @param reducer ((current: T, action: A) -> T)? Optional optimistic reducer.
--- @return T Current optimistic value.
--- @return (action: A) -> () Optimistic dispatcher.
function module.useOptimistic<T, A>(value: T, reducer: ((current: T, action: A) -> T)?): (T, (action: A) -> ())
	local optimistic, setOptimistic = module.useState(value)
	local baseRef = module.useRef(value)
	local registeredTransitions = module.useRef({} :: { [number]: boolean })

	baseRef.current = value

	module.useLayoutEffect(function()
		if transitionModule.isActive() then
			return nil
		end
		setOptimistic(value)
		return nil
	end, createDependencies(value))

	--- Applies an optimistic update and schedules restoration after its transition.
	--- @param action A Optimistic action or replacement value.
	local function dispatch(action: A)
		if not transitionModule.isActive() then
			devMode.warnIf(true, "Reactily optimistic updates should run inside startTransition or an Action.")
		end

		if reducer then
			setOptimistic(function(current: T): T
				return reducer(current, action)
			end)
		else
			setOptimistic(action :: any)
		end

		local transitionId = transitionModule.getCurrentId()
		if not transitionId or registeredTransitions.current[transitionId] then
			return
		end

		registeredTransitions.current[transitionId] = true
		transitionModule.onCurrentFinished(function()
			registeredTransitions.current[transitionId] = nil
			setOptimistic(baseRef.current)
		end)
	end

	return optimistic, dispatch
end

--————————————————————————————————————————————————————————————————————--

--- Observes a Roblox property and rerenders only when that property changes.
--- @param instance Instance Roblox instance.
--- @param propertyName string Roblox property name.
--- @return T Current property value.
function module.useProperty<T>(instance: Instance, propertyName: string): T
	local target = instance :: any
	local value, setValue = module.useState(target[propertyName] :: T)

	module.useEffect(function()
		setValue(target[propertyName] :: T)

		local connection = instance:GetPropertyChangedSignal(propertyName):Connect(function()
			setValue(target[propertyName] :: T)
		end)

		return function()
			connection:Disconnect()
		end
	end, createDependencies(instance, propertyName))

	return value
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component-owned keyboard shortcut.
--- @param options shortcutOptions Shortcut configuration.
--- @param callback () -> () Shortcut callback.
function module.useShortcut(options: shortcutModule.ShortcutOptions, callback: () -> ())
	local stableCallback = useStableEvent(callback)

	module.useEffect(function()
		local shortcut = shortcutModule.create(options, stableCallback)
		return function()
			shortcut.delete()
		end
	end, createDependencies(options.key, options.allowProcessed, options.enabled, options.modifiers))
end

--————————————————————————————————————————————————————————————————————--

--- Subscribes to an external store using the React-style snapshot contract.
--- @param subscribe (callback: () -> ()) -> () -> () Subscription factory.
--- @param getSnapshot () -> T Current snapshot getter.
--- @return T Current external-store snapshot.
function module.useSyncExternalStore<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
	return useExternalSnapshot(subscribe, getSnapshot)
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether a Roblox Instance currently has a CollectionService tag.
--- @param instance Instance Instance to observe.
--- @param tag string CollectionService tag.
--- @return boolean Whether the tag is present.
function module.useTag(instance: Instance, tag: string): boolean
	local tagged, setTagged = module.useState(collectionService:HasTag(instance, tag))

	module.useEffect(function()
		setTagged(collectionService:HasTag(instance, tag))

		local addedConnection = collectionService:GetInstanceAddedSignal(tag):Connect(function(added: Instance)
			if added ~= instance then
				return
			end
			setTagged(true)
		end)
		local removedConnection = collectionService:GetInstanceRemovedSignal(tag):Connect(function(removed: Instance)
			if removed ~= instance then
				return
			end
			setTagged(false)
		end)

		return function()
			addedConnection:Disconnect()
			removedConnection:Disconnect()
		end
	end, createDependencies(instance, tag))

	return tagged
end

--————————————————————————————————————————————————————————————————————--

--- React-compatible action-state hook for Roblox UI actions and forms.
--- @param action (state: S, payload: P) -> S Action reducer.
--- @param initialState S Initial action state.
--- @return S Current action state.
--- @return (payload: P) -> () Dispatch function.
--- @return boolean Whether dispatched transition work is pending.
function module.useActionState<S, P>(action: (state: S, payload: P) -> S, initialState: S): (S, (payload: P) -> (), boolean)
	local state, setState = module.useState(initialState)
	local pending, setPending = module.useState(false)
	local stateRef = module.useRef(state)
	local queueRef = module.useRef({} :: { P })
	local runningRef = module.useRef(false)
	local failure, setFailure = module.useState(nil :: any)
	local stableAction = useStableEvent(action)

	stateRef.current = state

	if failure ~= nil then
		error(failure, 0)
	end

	local dispatch = useStableEvent(function(payload: P)
		queueRef.current[#queueRef.current + 1] = payload
		setPending(true)

		if runningRef.current then
			return
		end

		runningRef.current = true
		transitionModule.start(function()
			while #queueRef.current > 0 do
				local nextPayload = table.remove(queueRef.current, 1) :: P
				local success, result = pcall(stableAction, stateRef.current, nextPayload)

				if not success then
					table.clear(queueRef.current)
					setFailure(result)
					break
				end

				local nextState = result :: S
				stateRef.current = nextState
				setState(nextState)
			end
		end, function()
			runningRef.current = false
			setPending(false)
		end)
	end)

	return state, dispatch, pending
end

--————————————————————————————————————————————————————————————————————--

--- Creates a stable React-style effect-event callback that sees current state.
--- @param callback T Current callback implementation.
--- @return T Stable callback identity.
function module.useEffectEvent<T>(callback: T): T
	return useStableEvent(callback)
end

--————————————————————————————————————————————————————————————————————--

return module
