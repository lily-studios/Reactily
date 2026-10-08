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

--- @reactilyType command
export type command = {
	canExecute: (() -> boolean)?,
	execute: (...any) -> (),
}

--- @reactilyType commandRegistry
export type commandRegistry = {
	bindKey: (name: string, keyCode: Enum.KeyCode, modifiers: { Enum.KeyCode }?) -> inputModule.inputBinding,
	delete: () -> boolean,
	execute: (name: string, ...any) -> boolean,
	has: (name: string) -> boolean,
	isDeleted: () -> boolean,
	register: (name: string, commandValue: command) -> boolean,
	remove: (name: string) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a command registry that can share actions across buttons, menus, and shortcuts.
--- @return commandRegistry Owned command registry.
function module.create(): commandRegistry
	local bindings: { inputModule.inputBinding } = {}
	local commands: { [string]: command } = {}
	local isDeleted = false

	local function execute(name: string, ...: any): boolean
		assert(not isDeleted, "Reactily command registry is deleted.")
		local commandValue = commands[name]
		if not commandValue then
			return false
		end
		if commandValue.canExecute and not commandValue.canExecute() then
			return false
		end

		commandValue.execute(...)
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
		local binding = inputModule.bindKey(keyCode, function()
			execute(name)
		end, {
			modifiers = modifiers,
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
			binding.delete()
		end
		table.clear(bindings)
		table.clear(commands)
		return true
	end

	return {
		bindKey = bindKey,
		delete = delete,
		execute = execute,
		has = function(name: string): boolean
			return not isDeleted and commands[name] ~= nil
		end,
		isDeleted = function(): boolean
			return isDeleted
		end,
		register = register,
		remove = remove,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
