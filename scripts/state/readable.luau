--[[
	Reactily · Lily Studios
	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]
--!strict

local contextModule = require(script.Parent.context)

local module = {}

local function isContext(value: any): boolean
	return type(value) == "table" and value.__reactilyContext == true and type(value.id) == "number"
end

local function isResource(value: any): boolean
	return type(value) == "table" and type(value.read) == "function" and type(value.getStatus) == "function"
end

--- Reads a Reactily context or Suspense resource during render.
--- Unlike slot-based hooks, this may be called conditionally.
--- @param readable any Context or resource.
--- @return T Current value.
function module.use<T>(readable: any): T
	if isResource(readable) then
		return readable.read() :: T
	end
	if isContext(readable) then
		return contextModule.get(readable) :: T
	end
	error("Reactily.use() expects a Reactily context or resource.", 2)
end

return module
