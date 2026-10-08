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
	__reactilyContext: true,
	DefaultValue: T,
	Id: number,
}

type contextStackValue = {
	Value: any,
}

type contextRecord = {
	Stack: { contextStackValue },
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
function module.Get<T>(contextValue: context<T>): T
	local record = records[contextValue]

	if not record then
		return contextValue.DefaultValue
	end

	local entry = record.Stack[#record.Stack]

	if not entry then
		return contextValue.DefaultValue
	end

	return entry.Value :: T
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Reactily context with a fallback value.
--- @param defaultValue T Value returned when no provider is active.
--- @return context<T> New context descriptor.
function module.New<T>(defaultValue: T): context<T>
	nextContextId += 1

	local contextValue: context<T> = {
		__reactilyContext = true,
		DefaultValue = defaultValue,
		Id = nextContextId,
	}

	records[contextValue] = {
		Stack = {},
	}

	return contextValue
end

--————————————————————————————————————————————————————————————————————--

--- Removes the most recently pushed provider value.
--- @param contextValue context<T> Context whose provider scope is ending.
function module.Pop<T>(contextValue: context<T>)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")
	assert(#record.Stack > 0, "Reactily context provider stack is empty.")

	record.Stack[#record.Stack] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Pushes a provider value for the duration of descendant reconciliation.
--- @param contextValue context<T> Context being provided.
--- @param value T Value visible to descendants.
function module.Push<T>(contextValue: context<T>, value: T)
	local record = records[contextValue]

	assert(record, "Reactily context is not registered.")

	record.Stack[#record.Stack + 1] = {
		Value = value,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
