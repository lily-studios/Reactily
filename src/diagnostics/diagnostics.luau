--!strict

-- provides lightweight named diagnostic counters

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type diagnostics = {
	delete: () -> boolean,
	get: (name: string) -> number,
	increment: (name: string, amount: number?) -> number,
	isDeleted: () -> boolean,
	reset: (name: string) -> boolean,
	resetAll: () -> (),
	snapshot: () -> {[string]: number},
}

--————————————————————————————————————————————————————————————————————--

--- Creates a diagnostics counter collection.
--- @return diagnostics A new diagnostics object.
function module.new(): diagnostics
	local counters: {[string]: number} = {}
	local isDeleted = false

	--- Deletes the diagnostics object and clears all counters.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true

		table.clear(counters)

		return true
	end

	--- Returns the current value of a named counter.
	--- Missing counters return zero.
	--- @param name string Counter name.
	--- @return number Current counter value.
	local function get(name: string): number
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		local value = counters[name]

		if value == nil then return 0 end

		return value
	end

	--- Increments a named counter.
	--- @param name string Counter name.
	--- @param amount number? Amount to add. Defaults to one.
	--- @return number Updated counter value.
	local function increment(name: string, amount: number?): number
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		local incrementAmount = 1

		if amount ~= nil then
			incrementAmount = amount
		end

		local nextValue = get(name) + incrementAmount

		counters[name] = nextValue

		return nextValue
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--- Removes a named counter.
	--- @param name string Counter name.
	--- @return boolean Whether the counter existed and was removed.
	local function reset(name: string): boolean
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		if counters[name] == nil then return false end

		counters[name] = nil

		return true
	end

	--- Clears all diagnostic counters.
	local function resetAll()
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		table.clear(counters)
	end

	--- Returns a copy of the current counter values.
	--- @return {[string]: number} Snapshot of all diagnostic counters.
	local function snapshot(): {[string]: number}
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		return table.clone(counters)
	end

	return {
		delete = delete,
		get = get,
		increment = increment,
		isDeleted = getIsDeleted,
		reset = reset,
		resetAll = resetAll,
		snapshot = snapshot,
	}
end

--————————————————————————————————————————————————————————————————————--

return module