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

--- @reactilyType Command
export type command = {
	CanExecute: (() -> boolean)?,
	Execute: (...any) -> (),
}

--- @reactilyType CommandRegistry
export type commandRegistry = {
	BindKey: (name: string, keyCode: Enum.KeyCode, modifiers: { Enum.KeyCode }?) -> inputModule.inputBinding,
	Delete: () -> boolean,
	Execute: (name: string, ...any) -> boolean,
	Has: (name: string) -> boolean,
	IsDeleted: () -> boolean,
	Register: (name: string, commandValue: command) -> boolean,
	Remove: (name: string) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a command registry that can share actions across buttons, menus, and shortcuts.
--- @return commandRegistry Owned command registry.
function module.Create(): commandRegistry
	local bindings: { inputModule.inputBinding } = {}
	local commands: { [string]: command } = {}
	local isDeleted = false

	local function execute(name: string, ...: any): boolean
		assert(not isDeleted, "Reactily command registry is deleted.")
		local commandValue = commands[name]
		if not commandValue then
			return false
		end
		if commandValue.CanExecute and not commandValue.CanExecute() then
			return false
		end

		commandValue.Execute(...)
		return true
	end

	local function register(name: string, commandValue: command): boolean
		assert(not isDeleted, "Reactily command registry is deleted.")
		assert(name ~= "", "Reactily command name cannot be empty.")
		assert(commands[name] == nil, `Reactily command "{name}" is already registered.`)
		commands[name] = commandValue
		return true
	end

	local function remove(name: string): boolean
		assert(not isDeleted, "Reactily command registry is deleted.")
		if not commands[name] then
			return false
		end

		commands[name] = nil
		return true
	end

	local function bindKey(name: string, keyCode: Enum.KeyCode, modifiers: { Enum.KeyCode }?): inputModule.inputBinding
		assert(not isDeleted, "Reactily command registry is deleted.")
		local binding = inputModule.BindKey(keyCode, function()
			execute(name)
		end, {
			Modifiers = modifiers,
		})
		bindings[#bindings + 1] = binding
		return binding
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		for _, binding in bindings do
			binding.Delete()
		end
		table.clear(bindings)
		table.clear(commands)
		return true
	end

	return {
		BindKey = bindKey,
		Delete = delete,
		Execute = execute,
		Has = function(name: string): boolean
			return not isDeleted and commands[name] ~= nil
		end,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		Register = register,
		Remove = remove,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
