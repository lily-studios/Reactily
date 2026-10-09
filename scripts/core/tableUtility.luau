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

--- Returns a shallow clone with the supplied fields replaced.
--- @param source T Source table that remains unchanged.
--- @param changes {[any]: any} Fields to assign on the clone.
--- @return T New patched table.
function module.patch<T>(source: T, changes: { [any]: any }): T
	assert(type(source) == "table", "Reactily.patch source must be a table.")

	local output: any = table.clone(source :: any)

	for key, value in changes do
		output[key] = value
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
