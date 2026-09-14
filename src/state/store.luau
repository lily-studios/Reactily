--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local batching = require(script.Parent.Parent.core.batching)
local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type change<T> = {
	current: T,
	previous: T,
}

export type middleware<T> = (previous: T, nextValue: T) -> T

export type selector<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: change<T>) -> ()) -> signalModule.connection,
}

export type store<T> = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	reset: () -> boolean,
	select: <R>((state: T) -> R) -> selector<R>,
	set: (state: T) -> boolean,
	subscribe: (callback: (change: change<T>) -> ()) -> signalModule.connection,
	transaction: (callback: () -> ()) -> (),
	update: (updater: (state: T) -> T) -> boolean,
	use: (middlewareValue: middleware<T>) -> () -> (),
}

type previousState<T> = {
	value: T,
}

--————————————————————————————————————————————————————————————————————--

--- Combines multiple stores into one derived selector.
--- @param stores {store<any>} Source stores.
--- @param selectorFunction (values: {any}) -> R Function deriving the combined value.
--- @return selector<R> Derived selector that updates only when its output changes.
function module.combine<R>(stores: { store<any> }, selectorFunction: (values: { any }) -> R): selector<R>
	local changed: signalModule.signal<change<R>> = signalModule.new()
	local connections: { signalModule.connection } = {}
	local isDeleted = false

	local function getValues(): { any }
		local values = table.create(#stores)

		for index, storeValue in stores do
			values[index] = storeValue.get()
		end

		return values
	end

	local selected = selectorFunction(getValues())

	local function update()
		if isDeleted then
			return
		end

		local nextValue = selectorFunction(getValues())
		if nextValue == selected then
			return
		end

		local previous = selected
		selected = nextValue

		changed.fire({
			current = nextValue,
			previous = previous,
		})
	end

	for _, storeValue in stores do
		connections[#connections + 1] = storeValue.subscribe(function()
			update()
		end)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in connections do
			connection.disconnect()
		end

		table.clear(connections)
		changed.delete()

		return true
	end

	local function get(): R
		assert(not isDeleted, "Reactily combined selector is deleted.")

		return selected
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function subscribe(callback: (change: change<R>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily combined selector is deleted.")

		return changed.connect(callback)
	end

	return {
		delete = delete,
		get = get,
		isDeleted = getIsDeleted,
		subscribe = subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily store.
--- @param initialState T Initial store state.
--- @return store<T> New store with selectors, transactions, and middleware.
function module.new<T>(initialState: T): store<T>
	local activeSelectors: { () -> boolean } = {}
	local batchDepth = 0
	local batchedPrevious: previousState<T>? = nil
	local changed: signalModule.signal<change<T>> = signalModule.new()
	local isDeleted = false
	local middlewares: { middleware<T> } = {}
	local state = initialState
	local flushGlobalBatch: () -> ()

	local function removeSelector(deleteSelector: () -> boolean)
		for index, currentDelete in activeSelectors do
			if currentDelete ~= deleteSelector then
				continue
			end

			table.remove(activeSelectors, index)
			return
		end
	end

	local function fireChange(previous: T)
		changed.fire({
			current = state,
			previous = previous,
		})
	end

	flushGlobalBatch = function()
		local pending = batchedPrevious
		batchedPrevious = nil

		if not pending then
			return
		end
		if pending.value == state then
			return
		end

		fireChange(pending.value)
	end

	local function emit(previous: T)
		if batchDepth > 0 then
			if batchedPrevious then
				return
			end

			batchedPrevious = {
				value = previous,
			}

			return
		end

		if batching.isBatching() then
			if not batchedPrevious then
				batchedPrevious = {
					value = previous,
				}
			end

			batching.queue(flushGlobalBatch)
			return
		end

		fireChange(previous)
	end

	local function get(): T
		assert(not isDeleted, "Reactily store is deleted.")

		return state
	end

	local function set(nextState: T): boolean
		assert(not isDeleted, "Reactily store is deleted.")

		local resolved = nextState

		for _, middlewareValue in middlewares do
			resolved = middlewareValue(state, resolved)
		end

		if state == resolved then
			return false
		end

		local previous = state
		state = resolved
		emit(previous)

		return true
	end

	local function batch(callback: () -> ())
		assert(not isDeleted, "Reactily store is deleted.")

		batchDepth += 1

		local success, failure = pcall(function(): boolean
			callback()

			return true
		end)

		batchDepth -= 1

		if batchDepth == 0 and batchedPrevious then
			local previous = batchedPrevious.value
			batchedPrevious = nil

			if previous ~= state then
				if batching.isBatching() then
					emit(previous)
				else
					fireChange(previous)
				end
			end
		end

		if success then
			return
		end

		error(failure, 0)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		local selectorDeletions = table.clone(activeSelectors)
		table.clear(activeSelectors)

		for _, deleteSelector in selectorDeletions do
			deleteSelector()
		end

		table.clear(selectorDeletions)
		table.clear(middlewares)
		changed.delete()

		batchedPrevious = nil

		return true
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function reset(): boolean
		return set(initialState)
	end

	local function select<R>(selectorFunction: (state: T) -> R): selector<R>
		assert(not isDeleted, "Reactily store is deleted.")

		local selectorChanged: signalModule.signal<change<R>> = signalModule.new()
		local selectorIsDeleted = false
		local selected = selectorFunction(state)

		local storeConnection = changed.connect(function(storeChange: change<T>)
			if selectorIsDeleted then
				return
			end

			local nextValue = selectorFunction(storeChange.current)
			if nextValue == selected then
				return
			end

			local previous = selected
			selected = nextValue

			selectorChanged.fire({
				current = nextValue,
				previous = previous,
			})
		end)

		local deleteSelector: () -> boolean

		deleteSelector = function(): boolean
			if selectorIsDeleted then
				return false
			end

			selectorIsDeleted = true

			storeConnection.disconnect()
			selectorChanged.delete()
			removeSelector(deleteSelector)

			return true
		end

		local function getSelected(): R
			assert(not selectorIsDeleted, "Reactily selector is deleted.")

			return selected
		end

		local function getSelectorIsDeleted(): boolean
			return selectorIsDeleted
		end

		local function subscribeSelector(callback: (change: change<R>) -> ()): signalModule.connection
			assert(not selectorIsDeleted, "Reactily selector is deleted.")

			return selectorChanged.connect(callback)
		end

		activeSelectors[#activeSelectors + 1] = deleteSelector

		return {
			delete = deleteSelector,
			get = getSelected,
			isDeleted = getSelectorIsDeleted,
			subscribe = subscribeSelector,
		}
	end

	local function subscribe(callback: (change: change<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily store is deleted.")

		return changed.connect(callback)
	end

	local function update(updater: (state: T) -> T): boolean
		assert(not isDeleted, "Reactily store is deleted.")

		return set(updater(state))
	end

	local function use(middlewareValue: middleware<T>): () -> ()
		assert(not isDeleted, "Reactily store is deleted.")
		assert(type(middlewareValue) == "function", "Reactily store middleware must be a function.")

		middlewares[#middlewares + 1] = middlewareValue

		local connected = true

		return function()
			if not connected then
				return
			end

			connected = false

			local index = table.find(middlewares, middlewareValue)
			if not index then
				return
			end

			table.remove(middlewares, index)
		end
	end

	return {
		batch = batch,
		delete = delete,
		get = get,
		isDeleted = getIsDeleted,
		reset = reset,
		select = select,
		set = set,
		subscribe = subscribe,
		transaction = batch,
		update = update,
		use = use,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived selector from one store.
--- @param source store<T> Source store.
--- @param selectorFunction (state: T) -> R Derivation callback.
--- @return selector<R> Derived selector.
function module.select<T, R>(source: store<T>, selectorFunction: (state: T) -> R): selector<R>
	return source.select(selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

return module
