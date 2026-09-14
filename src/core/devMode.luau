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

local strictModeEnabled = false

--————————————————————————————————————————————————————————————————————--

--- Returns whether Reactily strict development checks are enabled.
--- @return boolean Current strict-mode state.
function module.isStrictMode(): boolean
	return strictModeEnabled
end

--————————————————————————————————————————————————————————————————————--

--- Enables or disables additional development-time Reactily warnings.
--- @param enabled boolean New strict-mode state.
function module.setStrictMode(enabled: boolean)
	strictModeEnabled = enabled
end

--————————————————————————————————————————————————————————————————————--

--- Emits a warning only while strict mode is enabled.
--- @param condition boolean Condition that triggers the warning.
--- @param message string Warning text.
function module.warnIf(condition: boolean, message: string)
	if not strictModeEnabled then
		return
	end
	if not condition then
		return
	end

	warn(message)
end

--————————————————————————————————————————————————————————————————————--

return module
