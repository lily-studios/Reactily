--!strict

-- implements typed Reactily component hooks and effect deletion

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

type cleanup = () -> ()
type dependencyList = {any}

type hookSlot = {
	callback: any,
	cleanup: cleanup?,
	dependencies: dependencyList?,
	isInitialized: boolean,
	kind: string,
	value: any,
}

type pendingEffect = {
	callback: () -> cleanup?,
	slot: hookSlot,
}

export type componentContext = {
	hookIndex: number,
	hooks: {hookSlot},
	isDeleted: boolean,
	isRendered: boolean,
	pendingEffects: {pendingEffect},
	renderedHookCount: number,
	requestRender: () -> (),
}

export type counterControls = {
	decrement: (amount: number?) -> (),
	increment: (amount: number?) -> (),
	reset: () -> (),
	set: (value: number) -> (),
}

export type reducerDispatch<A> = (action: A) -> ()

export type ref<T> = {
	current: T,
}

export type stateSetter<T> = (value: T | ((previous: T) -> T)) -> ()

--————————————————————————————————————————————————————————————————————--

local currentContext: componentContext? = nil

--————————————————————————————————————————————————————————————————————--

local function dependenciesChanged(previous: dependencyList?, current: dependencyList?): boolean
	if previous == nil then return true end
	if current == nil then return true end
	if #previous ~= #current then return true end

	for index, value in current do
		if previous[index] == value then continue end

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

	local slot = context.hooks[context.hookIndex]

	if slot then
		assert(slot.kind == kind, `Reactily hook order changed from "{slot.kind}" to "{kind}".`)
		return slot
	end

	slot = {
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
	local success, failure = pcall(callback)
	if success then return end

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

function module.beginRender(context: componentContext)
	assert(not context.isDeleted, "Reactily component context is deleted.")
	assert(currentContext == nil, "Reactily component renders cannot overlap.")

	context.hookIndex = 0
	currentContext = context
end

--————————————————————————————————————————————————————————————————————--

function module.deleteContext(context: componentContext): boolean
	if context.isDeleted then return false end

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

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.endRender(context: componentContext, didComplete: boolean)
	assert(currentContext == context, "Reactily render context does not match the active component.")

	currentContext = nil

	if not didComplete then
		table.clear(context.pendingEffects)

		if not context.isRendered then
			table.clear(context.hooks)
			return
		end

		for index = #context.hooks, context.renderedHookCount + 1, -1 do
			context.hooks[index] = nil
		end

		return
	end

	if context.isRendered then
		assert(context.hookIndex == context.renderedHookCount, "Reactily hook count changed between renders.")
	end

	context.isRendered = true
	context.renderedHookCount = context.hookIndex
end

--————————————————————————————————————————————————————————————————————--

function module.flushEffects(context: componentContext)
	if context.isDeleted then return end
	if #context.pendingEffects == 0 then return end

	local pendingEffects = context.pendingEffects
	context.pendingEffects = {}

	for _, effect in pendingEffects do
		if effect.slot.cleanup then
			runCleanup(effect.slot.cleanup)
			effect.slot.cleanup = nil
		end

		local success, cleanupOrFailure = pcall(effect.callback)

		if success then
			effect.slot.cleanup = cleanupOrFailure
			continue
		end

		warn(`Reactily effect failed: {cleanupOrFailure}`)
	end

	table.clear(pendingEffects)
end

--————————————————————————————————————————————————————————————————————--

function module.newContext(requestRender: () -> ()): componentContext
	return {
		hookIndex = 0,
		hooks = {},
		isDeleted = false,
		isRendered = false,
		pendingEffects = {},
		renderedHookCount = 0,
		requestRender = requestRender,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (T, (value: T) -> ())
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
			if nextValue == nil then return end

			setValue(nextValue :: T)
		end)

		return function()
			connection:Disconnect()
		end
	end, {instance, attributeName})

	local function set(nextValue: T)
		if instance:GetAttribute(attributeName) ~= nextValue then
			instance:SetAttribute(attributeName, nextValue)
		end

		setValue(nextValue)
	end

	return value, set
end

--————————————————————————————————————————————————————————————————————--

function module.useBoolean(initialValue: boolean?): (boolean, () -> (), () -> (), () -> ())
	local defaultValue = false

	if initialValue ~= nil then
		defaultValue = initialValue
	end

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

function module.useCallback<T>(callback: T, dependencies: dependencyList?): T
	return module.useMemo(function(): T
		return callback
	end, dependencies)
end

--————————————————————————————————————————————————————————————————————--

function module.useCounter(initialValue: number?): (number, counterControls)
	local defaultValue = 0

	if initialValue ~= nil then
		defaultValue = initialValue
	end

	local value, setValue = module.useState(defaultValue)

	local controls: counterControls = {
		decrement = function(amount: number?)
			local delta = 1

			if amount ~= nil then
				delta = amount
			end

			setValue(function(previous: number): number
				return previous - delta
			end)
		end,

		increment = function(amount: number?)
			local delta = 1

			if amount ~= nil then
				delta = amount
			end

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

function module.useDebouncedValue<T>(value: T, delaySeconds: number): T
	assert(delaySeconds >= 0, "Reactily debounce delay must be non-negative.")

	local debounced, setDebounced = module.useState(value)
	local generation = module.useRef(0)

	module.useEffect(function()
		generation.current += 1

		local currentGeneration = generation.current
		local thread = task.delay(delaySeconds, function()
			if generation.current ~= currentGeneration then return end

			setDebounced(value)
		end)

		return function()
			if coroutine.status(thread) == "dead" then return end

			task.cancel(thread)
		end
	end, {value, delaySeconds})

	return debounced
end

--————————————————————————————————————————————————————————————————————--

function module.useEffect(callback: () -> cleanup?, dependencies: dependencyList?)
	local context = getContext()
	local slot = getSlot(context, "effect")

	if slot.isInitialized and not dependenciesChanged(slot.dependencies, dependencies) then return end

	slot.isInitialized = true

	slot.dependencies = nil

	if dependencies then
		slot.dependencies = table.clone(dependencies)
	end

	context.pendingEffects[#context.pendingEffects + 1] = {
		callback = callback,
		slot = slot,
	}
end

--————————————————————————————————————————————————————————————————————--

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

function module.usePrevious<T>(value: T): T?
	local context = getContext()
	local slot = getSlot(context, "previous")
	local previous = slot.value :: T?

	slot.isInitialized = true
	slot.value = value

	return previous
end

--————————————————————————————————————————————————————————————————————--

function module.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, reducerDispatch<A>)
	local context = getContext()
	local slot = getSlot(context, "reducer")

	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = initialState
		slot.callback = function(action: A)
			if context.isDeleted then return end

			local previous = slot.value :: S
			local nextValue = reducer(previous, action)
			if previous == nextValue then return end

			slot.value = nextValue
			context.requestRender()
		end
	end

	return slot.value :: S, slot.callback :: reducerDispatch<A>
end

--————————————————————————————————————————————————————————————————————--

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

function module.useState<T>(initialValue: T): (T, stateSetter<T>)
	local context = getContext()
	local slot = getSlot(context, "state")

	if not slot.isInitialized then
		slot.isInitialized = true
		slot.value = initialValue
		slot.callback = function(nextValue: T | ((previous: T) -> T))
			if context.isDeleted then return end

			local previous = slot.value :: T
			local resolved = resolveStateValue(previous, nextValue)

			if previous == resolved then return end

			slot.value = resolved
			context.requestRender()
		end
	end

	return slot.value :: T, slot.callback :: stateSetter<T>
end

--————————————————————————————————————————————————————————————————————--

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

return module
