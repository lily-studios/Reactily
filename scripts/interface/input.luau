--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict


--————————————————————————————————————————————————————————————————————--

local userInputService = game:GetService("UserInputService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type InputOptions = {
	allowProcessed: boolean?,
	enabled: boolean?,
}

export type KeyOptions = InputOptions & {
	modifiers: { Enum.KeyCode }?,
}

export type InputBinding = {
	delete: () -> boolean,
	disable: () -> boolean,
	enable: () -> boolean,
	isDeleted: () -> boolean,
	isEnabled: () -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function modifiersPressed(modifiers: { Enum.KeyCode }?): boolean
	if not modifiers then
		return true
	end

	for _, keyCode in modifiers do
		if userInputService:IsKeyDown(keyCode) then
			continue
		end

		return false
	end

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Binds a filtered UserInputService InputBegan callback.
--- @param predicate (input: InputObject) -> boolean Input predicate.
--- @param callback (input: InputObject) -> () Callback for matching input.
--- @param options inputOptions? Binding options.
--- @return inputBinding Owned input binding.
function module.bind(
	predicate: (input: InputObject) -> boolean,
	callback: (input: InputObject) -> (),
	options: InputOptions?
): InputBinding
	local allowProcessed = false
	local enabled = true

	if options then
		allowProcessed = options.allowProcessed == true
		enabled = options.enabled ~= false
	end

	local isDeleted = false

	--——————————————————————————————————————————————————————————————————--

	local function onInputBegan(input: InputObject, gameProcessedEvent: boolean)
		if isDeleted then
			return
		end

		if not enabled then
			return
		end

		if gameProcessedEvent and not allowProcessed then
			return
		end

		if not predicate(input) then
			return
		end

		callback(input)
	end

	--——————————————————————————————————————————————————————————————————--

	local connection = userInputService.InputBegan:Connect(onInputBegan)

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		connection:Disconnect()

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function disable(): boolean
		if isDeleted then
			return false
		end

		if not enabled then
			return false
		end

		enabled = false

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function enable(): boolean
		if isDeleted then
			return false
		end

		if enabled then
			return false
		end

		enabled = true

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsEnabled(): boolean
		if isDeleted then
			return false
		end

		return enabled
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		delete = delete,
		disable = disable,
		enable = enable,
		isDeleted = getIsDeleted,
		isEnabled = getIsEnabled,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Binds a keyboard key with optional required modifiers.
--- @param keyCode Enum.KeyCode Key to bind.
--- @param callback (input: InputObject) -> () Callback for the key.
--- @param options keyOptions? Key binding options.
--- @return inputBinding Owned input binding.
function module.bindKey(keyCode: Enum.KeyCode, callback: (input: InputObject) -> (), options: KeyOptions?): InputBinding
	local modifiers: { Enum.KeyCode }? = nil
	local bindOptions: InputOptions? = nil

	if options then
		modifiers = options.modifiers

		bindOptions = {
			allowProcessed = options.allowProcessed,
			enabled = options.enabled,
		}
	end

	local function matchesKey(input: InputObject): boolean
		if input.KeyCode ~= keyCode then
			return false
		end

		return modifiersPressed(modifiers)
	end

	return module.bind(matchesKey, callback, bindOptions)
end

--————————————————————————————————————————————————————————————————————--

--- Binds a UserInputType such as mouse or touch input.
--- @param inputType Enum.UserInputType Input type to bind.
--- @param callback (input: InputObject) -> () Callback for the input.
--- @param options inputOptions? Binding options.
--- @return inputBinding Owned input binding.
function module.bindType(
	inputType: Enum.UserInputType,
	callback: (input: InputObject) -> (),
	options: InputOptions?
): InputBinding
	local function matchesInputType(input: InputObject): boolean
		return input.UserInputType == inputType
	end

	return module.bind(matchesInputType, callback, options)
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
export type KeyInputOptions = KeyOptions

return module
