--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict


--————————————————————————————————————————————————————————————————————--

local inputModule = require(script.Parent.input)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type ShortcutOptions = {
	allowProcessed: boolean?,
	enabled: boolean?,
	key: Enum.KeyCode,
	modifiers: { Enum.KeyCode }?,
}

--- Creates an owned keyboard shortcut.
--- @param options shortcutOptions Shortcut configuration.
--- @param callback () -> () Action invoked when the shortcut matches.
--- @return inputBinding Owned shortcut binding.
function module.create(options: ShortcutOptions, callback: () -> ()): inputModule.InputBinding
	return inputModule.bindKey(options.key, function()
		callback()
	end, {
		allowProcessed = options.allowProcessed,
		enabled = options.enabled,
		modifiers = options.modifiers,
	})
end

--————————————————————————————————————————————————————————————————————--

return module
