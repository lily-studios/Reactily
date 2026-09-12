--!strict

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

function module.new(): diagnostics
	local counters: {[string]: number} = {}
	local isDeleted = false

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true
		table.clear(counters)

		return true
	end

	local function get(name: string): number
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		local value = counters[name]
		if value == nil then return 0 end

		return value
	end

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

	local function reset(name: string): boolean
		assert(not isDeleted, "Reactily diagnostics is deleted.")
		if counters[name] == nil then return false end

		counters[name] = nil

		return true
	end

	local function resetAll()
		assert(not isDeleted, "Reactily diagnostics is deleted.")
		table.clear(counters)
	end

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
