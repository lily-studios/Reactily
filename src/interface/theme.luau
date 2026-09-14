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

local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

export type theme<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> signalModule.connection,
	update: (updater: (value: T) -> T) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive theme containing typed theme tokens.
--- @param initialValue T Initial theme tokens.
--- @return theme<T> Theme instance containing the supplied tokens.
function module.new<T>(initialValue: T): theme<T>
	local changed: signalModule.signal<T> = signalModule.new()

	local isDeleted = false
	local value = initialValue

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		changed.delete()

		return true
	end

	local function get(): T
		assert(not isDeleted, "Reactily theme is deleted.")

		return value
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily theme is deleted.")
		if value == nextValue then
			return false
		end

		value = nextValue
		changed.fire(nextValue)

		return true
	end

	local function subscribe(callback: (value: T) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily theme is deleted.")

		return changed.connect(callback)
	end

	local function update(updater: (value: T) -> T): boolean
		assert(not isDeleted, "Reactily theme is deleted.")

		local nextValue = updater(value)

		return set(nextValue)
	end

	return {
		delete = delete,
		get = get,
		isDeleted = getIsDeleted,
		set = set,
		subscribe = subscribe,
		update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Resolves a selected value from the current theme tokens.
--- @param themeValue theme<T> Theme to read.
--- @param selector (tokens: T) -> R Selector used to derive the result.
--- @return R Value returned by the selector.
function module.resolve<T, R>(themeValue: theme<T>, selector: (tokens: T) -> R): R
	return selector(themeValue.get())
end

--————————————————————————————————————————————————————————————————————--

return module
