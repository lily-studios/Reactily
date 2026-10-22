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

--- Performs a shallow key/value equality comparison between two tables.
--- @param first {[any]: any}? First table.
--- @param second {[any]: any}? Second table.
--- @return boolean True when both tables contain the same shallow keys and values.
function module.shallowEqual(first: { [any]: any }?, second: { [any]: any }?): boolean
	if first == second then
		return true
	end
	if not first or not second then
		return false
	end

	local firstCount = 0

	for key, value in first do
		firstCount += 1
		if second[key] ~= value then
			return false
		end
	end

	for _ in second do
		firstCount -= 1
		if firstCount < 0 then
			return false
		end
	end

	return firstCount == 0
end

--————————————————————————————————————————————————————————————————————--

return module
