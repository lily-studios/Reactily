--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type diagnostics = {
	Delete: () -> boolean,
	Get: (name: string) -> number,
	Increment: (name: string, amount: number?) -> number,
	IsDeleted: () -> boolean,
	Reset: (name: string) -> boolean,
	ResetAll: () -> (),
	Snapshot: () -> { [string]: number },
}

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily diagnostics counter collection.
--- @return diagnostics New diagnostics object for explicit runtime counters.
function module.New(): diagnostics
	local counters: { [string]: number } = {}
	local isDeleted = false

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		table.clear(counters)

		return true
	end

	local function get(name: string): number
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		local value = counters[name]
		if value == nil then
			return 0
		end

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
		if counters[name] == nil then
			return false
		end

		counters[name] = nil

		return true
	end

	local function resetAll()
		assert(not isDeleted, "Reactily diagnostics is deleted.")
		table.clear(counters)
	end

	local function snapshot(): { [string]: number }
		assert(not isDeleted, "Reactily diagnostics is deleted.")

		return table.clone(counters)
	end

	return {
		Delete = delete,
		Get = get,
		Increment = increment,
		IsDeleted = getIsDeleted,
		Reset = reset,
		ResetAll = resetAll,
		Snapshot = snapshot,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
