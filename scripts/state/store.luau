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
	Current: T,
	Previous: T,
}

export type middleware<T> = (previous: T, nextValue: T) -> T

export type selector<T> = {
	Delete: () -> boolean,
	Get: () -> T,
	IsDeleted: () -> boolean,
	Subscribe: (callback: (change: change<T>) -> ()) -> signalModule.connection,
}

export type store<T> = {
	Batch: (callback: () -> ()) -> (),
	Delete: () -> boolean,
	Get: () -> T,
	IsDeleted: () -> boolean,
	Reset: () -> boolean,
	Select: <R>((state: T) -> R) -> selector<R>,
	Set: (state: T) -> boolean,
	Subscribe: (callback: (change: change<T>) -> ()) -> signalModule.connection,
	Transaction: (callback: () -> ()) -> (),
	Update: (updater: (state: T) -> T) -> boolean,
	Use: (middlewareValue: middleware<T>) -> () -> (),
}

type previousState<T> = {
	Value: T,
}

--————————————————————————————————————————————————————————————————————--

--- Combines multiple stores into one derived selector.
--- @param stores {store<any>} Source stores.
--- @param selectorFunction (values: {any}) -> R Function deriving the combined value.
--- @return selector<R> Derived selector that updates only when its output changes.
function module.Combine<R>(stores: { store<any> }, selectorFunction: (values: { any }) -> R): selector<R>
	local changed: signalModule.signal<change<R>> = signalModule.New()
	local connections: { signalModule.connection } = {}
	local isDeleted = false

	local function getValues(): { any }
		local values = table.create(#stores)

		for index, storeValue in stores do
			values[index] = storeValue.Get()
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

		changed.Fire({
			Current = nextValue,
			Previous = previous,
		})
	end

	for _, storeValue in stores do
		connections[#connections + 1] = storeValue.Subscribe(function()
			update()
		end)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in connections do
			connection.Disconnect()
		end

		table.clear(connections)
		changed.Delete()

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

		return changed.Connect(callback)
	end

	return {
		Delete = delete,
		Get = get,
		IsDeleted = getIsDeleted,
		Subscribe = subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily store.
--- @param initialState T Initial store state.
--- @return store<T> New store with selectors, transactions, and middleware.
function module.New<T>(initialState: T): store<T>
	local activeSelectors: { () -> boolean } = {}
	local batchDepth = 0
	local batchedPrevious: previousState<T>? = nil
	local changed: signalModule.signal<change<T>> = signalModule.New()
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
		changed.Fire({
			Current = state,
			Previous = previous,
		})
	end

	flushGlobalBatch = function()
		local pending = batchedPrevious
		batchedPrevious = nil

		if not pending then
			return
		end
		if pending.Value == state then
			return
		end

		fireChange(pending.Value)
	end

	local function emit(previous: T)
		if batchDepth > 0 then
			if batchedPrevious then
				return
			end

			batchedPrevious = {
				Value = previous,
			}

			return
		end

		if batching.IsBatching() then
			if not batchedPrevious then
				batchedPrevious = {
					Value = previous,
				}
			end

			batching.Queue(flushGlobalBatch)
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
			local previous = batchedPrevious.Value
			batchedPrevious = nil

			if previous ~= state then
				if batching.IsBatching() then
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
		changed.Delete()

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

		local selectorChanged: signalModule.signal<change<R>> = signalModule.New()
		local selectorIsDeleted = false
		local selected = selectorFunction(state)

		local storeConnection = changed.Connect(function(storeChange: change<T>)
			if selectorIsDeleted then
				return
			end

			local nextValue = selectorFunction(storeChange.Current)
			if nextValue == selected then
				return
			end

			local previous = selected
			selected = nextValue

			selectorChanged.Fire({
				Current = nextValue,
				Previous = previous,
			})
		end)

		local deleteSelector: () -> boolean

		deleteSelector = function(): boolean
			if selectorIsDeleted then
				return false
			end

			selectorIsDeleted = true

			storeConnection.Disconnect()
			selectorChanged.Delete()
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

			return selectorChanged.Connect(callback)
		end

		activeSelectors[#activeSelectors + 1] = deleteSelector

		return {
			Delete = deleteSelector,
			Get = getSelected,
			IsDeleted = getSelectorIsDeleted,
			Subscribe = subscribeSelector,
		}
	end

	local function subscribe(callback: (change: change<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily store is deleted.")

		return changed.Connect(callback)
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
		Batch = batch,
		Delete = delete,
		Get = get,
		IsDeleted = getIsDeleted,
		Reset = reset,
		Select = select,
		Set = set,
		Subscribe = subscribe,
		Transaction = batch,
		Update = update,
		Use = use,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived selector from one store.
--- @param source store<T> Source store.
--- @param selectorFunction (state: T) -> R Derivation callback.
--- @return selector<R> Derived selector.
function module.Select<T, R>(source: store<T>, selectorFunction: (state: T) -> R): selector<R>
	return source.Select(selectorFunction)
end

--————————————————————————————————————————————————————————————————————--

return module
