--!strict

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")

local signalModule = require(core:WaitForChild("signal"))

--————————————————————————————————————————————————————————————————————--

export type change<T> = {
	current: T,
	previous: T,
}

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
	update: (updater: (state: T) -> T) -> boolean,
}

type previousState<T> = {
	value: T,
}

--————————————————————————————————————————————————————————————————————--

function module.new<T>(initialState: T): store<T>
	local activeSelectors: {() -> boolean} = {}

	local batchDepth = 0
	local batchedPrevious: previousState<T>? = nil
	local changed: signalModule.signal<change<T>> = signalModule.new()
	local isDeleted = false
	local state = initialState

	local function removeSelector(deleteSelector: () -> boolean)
		for index, currentDelete in activeSelectors do
			if currentDelete ~= deleteSelector then continue end

			table.remove(activeSelectors, index)

			return
		end
	end

	local function emit(previous: T)
		if batchDepth > 0 then
			if batchedPrevious then return end

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

	local function get(): T
		assert(not isDeleted, "Reactily store is deleted.")

		return state
	end

	local function set(nextState: T): boolean
		assert(not isDeleted, "Reactily store is deleted.")

		if state == nextState then return false end

		local previous = state

		state = nextState

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
				changed.fire({
					current = state,
					previous = previous,
				})
			end
		end

		if success then return end

		error(failure)
	end

	local function delete(): boolean
		if isDeleted then return false end

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
			if selectorIsDeleted then return end

			local nextValue = selectorFunction(storeChange.current)

			if nextValue == selected then return end

			local previous = selected

			selected = nextValue

			selectorChanged.fire({
				current = nextValue,
				previous = previous,
			})
		end)

		local deleteSelector: () -> boolean

		deleteSelector = function(): boolean
			if selectorIsDeleted then return false end

			selectorIsDeleted = true

			storeConnection.disconnect()
			selectorChanged.delete()
			removeSelector(deleteSelector)

			return true
		end

		activeSelectors[#activeSelectors + 1] = deleteSelector

		return {
			delete = deleteSelector,

			get = function(): R
				assert(not selectorIsDeleted, "Reactily selector is deleted.")

				return selected
			end,

			isDeleted = function(): boolean
				return selectorIsDeleted
			end,

			subscribe = function(callback: (change: change<R>) -> ()): signalModule.connection
				assert(not selectorIsDeleted, "Reactily selector is deleted.")

				return selectorChanged.connect(callback)
			end,
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