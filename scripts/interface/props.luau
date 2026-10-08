--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local compareModule = require(script.Parent.Parent.core.compare)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType PropMap
export type propMap = { [any]: any }

--————————————————————————————————————————————————————————————————————--

local function copy(source: propMap?): propMap
	if not source then
		return {}
	end

	return table.clone(source)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy of props with missing values filled from defaults.
--- @param props T Source props.
--- @param defaults propMap Default values used only when a key is absent.
--- @return T Copied props with defaults applied.
function module.Defaults<T>(props: T, defaults: propMap): T
	local output: any = copy(props :: any)

	for key, value in defaults do
		if output[key] ~= nil then
			continue
		end

		output[key] = value
	end

	return output :: T
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether two prop tables are shallowly equal.
--- @param first propMap First prop table.
--- @param second propMap Second prop table.
--- @return boolean Whether both tables contain the same shallow values.
function module.Equal(first: propMap, second: propMap): boolean
	return compareModule.ShallowEqual(first, second)
end

--————————————————————————————————————————————————————————————————————--

--- Returns changed current values plus keys that were removed.
--- @param previous propMap Previous props.
--- @param current propMap Current props.
--- @return propMap Map of changed or added keys to their current values.
--- @return {any} Keys that existed previously and are now absent.
function module.Changed(previous: propMap, current: propMap): (propMap, { any })
	local output: propMap = {}
	local removed: { any } = {}
	local seen: { [any]: boolean } = {}

	for key, value in previous do
		seen[key] = true

		local currentValue = current[key]
		if currentValue == value then
			continue
		end
		if currentValue == nil then
			removed[#removed + 1] = key
			continue
		end

		output[key] = currentValue
	end

	for key, value in current do
		if seen[key] then
			continue
		end

		output[key] = value
	end

	return output, removed
end

--————————————————————————————————————————————————————————————————————--

--- Merges prop tables from left to right without mutating any input.
--- @param ... propMap Prop tables to merge.
--- @return propMap New merged prop table.
function module.Merge(...: propMap): propMap
	local output: propMap = {}

	for _, source in { ... } do
		for key, value in source do
			output[key] = value
		end
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy without the supplied keys.
--- @param props propMap Source props.
--- @param keys {any} Keys to remove.
--- @return propMap Copied props without omitted keys.
function module.Omit(props: propMap, keys: { any }): propMap
	local output = copy(props)

	for _, key in keys do
		output[key] = nil
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns a new table containing only the supplied keys.
--- @param props propMap Source props.
--- @param keys {any} Keys to include.
--- @return propMap Picked prop values.
function module.Pick(props: propMap, keys: { any }): propMap
	local output: propMap = {}

	for _, key in keys do
		local value = props[key]
		if value == nil then
			continue
		end

		output[key] = value
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
