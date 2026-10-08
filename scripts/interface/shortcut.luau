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

--- @reactilyType ShortcutOptions
export type shortcutOptions = {
	AllowProcessed: boolean?,
	Enabled: boolean?,
	Key: Enum.KeyCode,
	Modifiers: { Enum.KeyCode }?,
}

--- Creates an owned keyboard shortcut.
--- @param options shortcutOptions Shortcut configuration.
--- @param callback () -> () Action invoked when the shortcut matches.
--- @return inputBinding Owned shortcut binding.
function module.Create(options: shortcutOptions, callback: () -> ()): inputModule.inputBinding
	return inputModule.BindKey(options.Key, function()
		callback()
	end, {
		AllowProcessed = options.AllowProcessed,
		Enabled = options.Enabled,
		Modifiers = options.Modifiers,
	})
end

--————————————————————————————————————————————————————————————————————--

return module
