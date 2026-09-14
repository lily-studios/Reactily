--!strict

-- provides reactive stores, batching, subscriptions, and derived selectors

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")

local signalModule = require(core:WaitForChild("signal"))

--————————————————————————————————————————————————————————————————————--

export type storeChange<T> = {
	current: T,
	previous: T,
}

export type selector<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: storeChange<T>) -> ()) -> signalModule.connection,
}

export type store<T> = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	reset: () -> boolean,
	select: <R>((state: T) -> R) -> selector<R>,
	set: (state: T) -> boolean,
	subscribe: (callback: (change: storeChange<T>) -> ()) -> signalModule.connection,
	update: (updater: (state: T) -> T) -> boolean,
}

type previousState<T> = {
	value: T,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive store with subscriptions, batching, and derived selectors.
--- @param initialState T Initial store state and value restored by reset().
--- @return store<T> A new store.
function module.new<T>(initialState: T): store<T>
	local activeSelectors: { () -> boolean } = {}
	local batchDepth = 0
	local batchedPrevious: previousState<T>? = nil
	local changed: signalModule.signal<storeChange<T>> = signalModule.new()
	local isDeleted = false
	local state = initialState

	--————————————————————————————————————————————————————————————————————--

	local function removeSelector(deleteSelector: () -> boolean)
		for index, currentDeleteSelector in activeSelectors do
			if currentDeleteSelector ~= deleteSelector then
				continue
			end

			table.remove(activeSelectors, index)

			return
		end
	end

	--————————————————————————————————————————————————————————————————————--

	local function emitChange(previous: T)
		if batchDepth > 0 then
			if batchedPrevious then
				return
			end

			batchedPrevious = {
				value = previous,
			}

			return
		end

		changed.fire({
			current = state,
			previous = previous,
		})
	end

	--————————————————————————————————————————————————————————————————————--

	local function get(): T
		assert(not isDeleted, "Reactily store is deleted.")

		return state
	end

	--————————————————————————————————————————————————————————————————————--

	--- Replaces the current store state.
	--- Subscribers are notified only when the state changes.
	--- @param nextState T New store state.
	--- @return boolean Whether the state changed.
	local function set(nextState: T): boolean
		assert(not isDeleted, "Reactily store is deleted.")
		if state == nextState then
			return false
		end

		local previous = state

		state = nextState

		emitChange(previous)

		return true
	end

	--————————————————————————————————————————————————————————————————————--

	--- Groups multiple state changes into one final notification.
	--- Nested batches are supported.
	--- @param callback () -> () Callback containing the updates to batch.
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
				changed.fire({
					current = state,
					previous = previous,
				})
			end
		end

		if success then
			return
		end

		error(failure)
	end

	--————————————————————————————————————————————————————————————————————--

	--- Deletes the store, active selectors, and all store subscriptions.
	--- @return boolean Whether deletion occurred.
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

		changed.delete()

		batchedPrevious = nil

		return true
	end

	--————————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--————————————————————————————————————————————————————————————————————--

	--- Restores the store to its initial state.
	--- @return boolean Whether resetting changed the current state.
	local function reset(): boolean
		return set(initialState)
	end

	--————————————————————————————————————————————————————————————————————--

	--- Creates derived state from the store.
	--- The selector notifies subscribers only when its selected value changes.
	--- @param selectorFunction (state: T) -> R Function that derives the selected value.
	--- @return selector<R> A derived selector owned by the store.
	local function select<R>(selectorFunction: (state: T) -> R): selector<R>
		assert(not isDeleted, "Reactily store is deleted.")

		local selectorChanged: signalModule.signal<storeChange<R>> = signalModule.new()
		local selectorIsDeleted = false
		local selected = selectorFunction(state)

		local storeConnection = changed.connect(function(storeChangeValue: storeChange<T>)
			if selectorIsDeleted then
				return
			end

			local nextValue = selectorFunction(storeChangeValue.current)

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

		--————————————————————————————————————————————————————————————————————--

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

		--————————————————————————————————————————————————————————————————————--

		local function getSelected(): R
			assert(not selectorIsDeleted, "Reactily selector is deleted.")

			return selected
		end

		--————————————————————————————————————————————————————————————————————--

		local function getIsSelectorDeleted(): boolean
			return selectorIsDeleted
		end

		--————————————————————————————————————————————————————————————————————--

		--- Subscribes to future selector value changes.
		--- @param callback (change: storeChange<R>) -> () Callback receiving previous and current values.
		--- @return signalModule.connection Connection used to stop future notifications.
		local function subscribeSelector(callback: (change: storeChange<R>) -> ()): signalModule.connection
			assert(not selectorIsDeleted, "Reactily selector is deleted.")

			return selectorChanged.connect(callback)
		end

		activeSelectors[#activeSelectors + 1] = deleteSelector

		return {
			delete = deleteSelector,
			get = getSelected,
			isDeleted = getIsSelectorDeleted,
			subscribe = subscribeSelector,
		}
	end

	--————————————————————————————————————————————————————————————————————--

	--- Subscribes to future store changes.
	--- @param callback (change: storeChange<T>) -> () Callback receiving previous and current state.
	--- @return signalModule.connection Connection used to stop future notifications.
	local function subscribe(callback: (change: storeChange<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily store is deleted.")

		return changed.connect(callback)
	end

	--————————————————————————————————————————————————————————————————————--

	--- Updates the store using its current state.
	--- @param updater (state: T) -> T Function that returns the next state.
	--- @return boolean Whether the resulting state changed.
	local function update(updater: (state: T) -> T): boolean
		assert(not isDeleted, "Reactily store is deleted.")

		return set(updater(state))
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
		update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
