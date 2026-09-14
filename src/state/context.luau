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

export type context<T> = {
	defaultValue: T,
	id: number,
}

type contextRecord = {
	stack: { any },
}

type contextRecords = {
	[any]: contextRecord,
}

--————————————————————————————————————————————————————————————————————--

local nextContextId = 0
local records: contextRecords = {}

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
function module.get<T>(contextValue: context<T>): T
	local record = records[contextValue]

	if not record then
		return contextValue.defaultValue
	end

	local value = record.stack[#record.stack]

	if value == nil then
		return contextValue.defaultValue
	end

	return value :: T
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily context with a fallback value.
--- @param defaultValue T Value returned when no provider is active.
--- @return context<T> New context descriptor.
function module.new<T>(defaultValue: T): context<T>
	nextContextId += 1

	local contextValue: context<T> = {
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
function module.pop<T>(contextValue: context<T>)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")
	assert(#record.stack > 0, "Reactily context provider stack is empty.")

	record.stack[#record.stack] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Pushes a provider value for the duration of descendant reconciliation.
--- @param contextValue context<T> Context being provided.
--- @param value T Value visible to descendants.
function module.push<T>(contextValue: context<T>, value: T)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")

	record.stack[#record.stack + 1] = value
end

--————————————————————————————————————————————————————————————————————--

return module
