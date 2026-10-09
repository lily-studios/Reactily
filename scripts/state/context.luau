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

export type Context<T> = {
	__reactilyContext: true,
	defaultValue: T,
	id: number,
}

type ContextStackValue = {
	value: any,
}

type ContextRecord = {
	stack: { ContextStackValue },
}

type ContextRecords = {
	[any]: ContextRecord,
}

--————————————————————————————————————————————————————————————————————--

local nextContextId = 0
local records: ContextRecords = {}

do
	local weakRecords: any = records

	setmetatable(weakRecords, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Returns the current value for a context, or its default outside a provider.
--- @param contextValue context<T> Context to read.
--- @return T Current context value.
function module.get<T>(contextValue: Context<T>): T
	local record = records[contextValue]

	if not record then
		return contextValue.defaultValue
	end

	local entry = record.stack[#record.stack]

	if not entry then
		return contextValue.defaultValue
	end

	return entry.value :: T
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily context with a fallback value.
--- @param defaultValue T Value returned when no provider is active.
--- @return context<T> New context descriptor.
function module.new<T>(defaultValue: T): Context<T>
	nextContextId += 1

	local contextValue: Context<T> = {
		__reactilyContext = true,
		defaultValue = defaultValue,
		id = nextContextId,
	}

	records[contextValue] = {
		stack = {},
	}

	return contextValue
end

--————————————————————————————————————————————————————————————————————--

--- Removes the most recently pushed provider value.
--- @param contextValue context<T> Context whose provider scope is ending.
function module.pop<T>(contextValue: Context<T>)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")
	assert(#record.stack > 0, "Reactily context provider stack is empty.")

	record.stack[#record.stack] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Pushes a provider value for the duration of descendant reconciliation.
--- @param contextValue context<T> Context being provided.
--- @param value T Value visible to descendants.
function module.push<T>(contextValue: Context<T>, value: T)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")

	record.stack[#record.stack + 1] = {
		value = value,
	}
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.createContext = module.new

return module
