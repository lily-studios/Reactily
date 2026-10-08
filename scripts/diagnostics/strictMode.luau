--[[
	Reactily · Lily Studios
	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]
--!strict

local module = {}

local enabled = true

function module.isEnabled(): boolean
	return enabled
end

function module.setEnabled(value: boolean)
	enabled = value
end

function module.warn(message: string)
	if enabled then
		warn(`[Reactily StrictMode] {message}`)
	end
end

return module
