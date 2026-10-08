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

--- @reactilyType resizeOptions
export type resizeOptions = {
	enabled: boolean?,
	maximumSize: Vector2?,
	minimumSize: Vector2?,
	onChanged: ((size: UDim2) -> ())?,
}

--- @reactilyType resizeController
export type resizeController = {
	delete: () -> boolean,
	disable: () -> boolean,
	enable: () -> boolean,
	isDeleted: () -> boolean,
	isEnabled: () -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function getInputPosition(input: InputObject): Vector2
	return Vector2.new(input.Position.X, input.Position.Y)
end

--————————————————————————————————————————————————————————————————————--

local function isResizeInput(input: InputObject): boolean
	local inputType = input.UserInputType

	if inputType == Enum.UserInputType.MouseButton1 then
		return true
	end

	if inputType == Enum.UserInputType.Touch then
		return true
	end

	return false
end

--————————————————————————————————————————————————————————————————————--

--- Makes a GuiObject resizable from a dedicated handle GuiObject.
--- @param target GuiObject Object whose Size is updated.
--- @param handle GuiObject Drag handle.
--- @param options resizeOptions? Resize behavior.
--- @return resizeController Owned resize controller.
function module.bind(target: GuiObject, handle: GuiObject, options: resizeOptions?): resizeController
	local enabled = true
	local maximumSize = Vector2.new(math.huge, math.huge)
	local minimumSize = Vector2.zero
	local onChanged: ((size: UDim2) -> ())? = nil

	if options then
		if options.enabled ~= nil then
			enabled = options.enabled
		end

		if options.maximumSize ~= nil then
			maximumSize = options.maximumSize
		end

		if options.minimumSize ~= nil then
			minimumSize = options.minimumSize
		end

		if options.onChanged ~= nil then
			onChanged = options.onChanged
		end
	end

	assert(minimumSize.X <= maximumSize.X, "Reactily resize minimum width cannot exceed maximum width.")

	assert(minimumSize.Y <= maximumSize.Y, "Reactily resize minimum height cannot exceed maximum height.")

	local isDeleted = false

	local activeInput: InputObject? = nil

	local startAbsoluteSize = target.AbsoluteSize
	local startInputPosition = Vector2.zero
	local startSize = target.Size

	local moveConnection: RBXScriptConnection? = nil

	--——————————————————————————————————————————————————————————————————--

	local function disconnectMove()
		local connection = moveConnection

		if not connection then
			return
		end

		moveConnection = nil

		connection:Disconnect()
	end

	--——————————————————————————————————————————————————————————————————--

	local function stopResize()
		if not activeInput then
			return
		end

		activeInput = nil

		disconnectMove()
	end

	--——————————————————————————————————————————————————————————————————--

	local function shouldProcessChangedInput(input: InputObject): boolean
		local currentInput = activeInput

		if not currentInput then
			return false
		end

		local inputType = currentInput.UserInputType

		if inputType == Enum.UserInputType.Touch then
			return input == currentInput
		end

		if inputType == Enum.UserInputType.MouseButton1 then
			return input.UserInputType == Enum.UserInputType.MouseMovement
		end

		return false
	end

	--——————————————————————————————————————————————————————————————————--

	local function shouldProcessEndedInput(input: InputObject): boolean
		local currentInput = activeInput

		if not currentInput then
			return false
		end

		local inputType = currentInput.UserInputType

		if inputType == Enum.UserInputType.Touch then
			return input == currentInput
		end

		if inputType == Enum.UserInputType.MouseButton1 then
			return input.UserInputType == Enum.UserInputType.MouseButton1
		end

		return false
	end

	--——————————————————————————————————————————————————————————————————--

	local function update(input: InputObject)
		if isDeleted then
			return
		end

		if not enabled then
			return
		end

		if not shouldProcessChangedInput(input) then
			return
		end

		local inputPosition = getInputPosition(input)
		local delta = inputPosition - startInputPosition

		local nextAbsoluteSize = startAbsoluteSize + delta

		nextAbsoluteSize = Vector2.new(
			math.clamp(nextAbsoluteSize.X, minimumSize.X, maximumSize.X),
			math.clamp(nextAbsoluteSize.Y, minimumSize.Y, maximumSize.Y)
		)

		local appliedDelta = nextAbsoluteSize - startAbsoluteSize

		local nextSize = UDim2.new(
			startSize.X.Scale,
			startSize.X.Offset + appliedDelta.X,
			startSize.Y.Scale,
			startSize.Y.Offset + appliedDelta.Y
		)

		if target.Size == nextSize then
			return
		end

		target.Size = nextSize

		if onChanged then
			onChanged(nextSize)
		end
	end

	--——————————————————————————————————————————————————————————————————--

	local function onInputBegan(input: InputObject)
		if isDeleted then
			return
		end

		if not enabled then
			return
		end

		if activeInput then
			return
		end

		if not isResizeInput(input) then
			return
		end

		activeInput = input

		startAbsoluteSize = target.AbsoluteSize
		startInputPosition = getInputPosition(input)
		startSize = target.Size

		disconnectMove()

		moveConnection = userInputService.InputChanged:Connect(update)
	end

	--——————————————————————————————————————————————————————————————————--

	local function onInputEnded(input: InputObject)
		if isDeleted then
			return
		end

		if not shouldProcessEndedInput(input) then
			return
		end

		stopResize()
	end

	--——————————————————————————————————————————————————————————————————--

	local beganConnection = handle.InputBegan:Connect(onInputBegan)
	local endedConnection = userInputService.InputEnded:Connect(onInputEnded)

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		stopResize()

		beganConnection:Disconnect()
		endedConnection:Disconnect()

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

		stopResize()

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

return module
