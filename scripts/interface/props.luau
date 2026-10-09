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

export type PropMap = { [any]: any }

--————————————————————————————————————————————————————————————————————--

local function copy(source: PropMap?): PropMap
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
function module.defaults<T>(props: T, defaults: PropMap): T
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
function module.equal(first: PropMap, second: PropMap): boolean
	return compareModule.shallowEqual(first, second)
end

--————————————————————————————————————————————————————————————————————--

--- Returns changed current values plus keys that were removed.
--- @param previous propMap Previous props.
--- @param current propMap Current props.
--- @return propMap Map of changed or added keys to their current values.
--- @return {any} Keys that existed previously and are now absent.
function module.changed(previous: PropMap, current: PropMap): (PropMap, { any })
	local output: PropMap = {}
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
function module.merge(...: PropMap): PropMap
	local output: PropMap = {}

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
function module.omit(props: PropMap, keys: { any }): PropMap
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
function module.pick(props: PropMap, keys: { any }): PropMap
	local output: PropMap = {}

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
