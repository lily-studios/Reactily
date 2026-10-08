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

--- @reactilyType dragAxis
export type dragAxis = "Both" | "X" | "Y"

--- @reactilyType dragOptions
export type dragOptions = {
	axis: dragAxis?,
	clampToParent: boolean?,
	enabled: boolean?,
	handle: GuiObject?,
	onChanged: ((position: UDim2) -> ())?,
}

--- @reactilyType dragController
export type dragController = {
	delete: () -> boolean,
	disable: () -> boolean,
	enable: () -> boolean,
	isDeleted: () -> boolean,
	isEnabled: () -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function clampDelta(target: GuiObject, startAbsolutePosition: Vector2, delta: Vector2): Vector2
	local parent = target.Parent

	if not parent then
		return delta
	end

	if not parent:IsA("GuiObject") then
		return delta
	end

	local parentPosition = parent.AbsolutePosition
	local parentSize = parent.AbsoluteSize
	local targetSize = target.AbsoluteSize

	local nextX = startAbsolutePosition.X + delta.X
	local nextY = startAbsolutePosition.Y + delta.Y

	local minimumX = parentPosition.X
	local minimumY = parentPosition.Y

	local maximumX = minimumX + parentSize.X - targetSize.X
	local maximumY = minimumY + parentSize.Y - targetSize.Y

	maximumX = math.max(minimumX, maximumX)
	maximumY = math.max(minimumY, maximumY)

	local clampedX = math.clamp(nextX, minimumX, maximumX)
	local clampedY = math.clamp(nextY, minimumY, maximumY)

	return Vector2.new(clampedX - startAbsolutePosition.X, clampedY - startAbsolutePosition.Y)
end

--————————————————————————————————————————————————————————————————————--

local function isDragInput(input: InputObject): boolean
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

local function getInputPosition(input: InputObject): Vector2
	return Vector2.new(input.Position.X, input.Position.Y)
end

--————————————————————————————————————————————————————————————————————--

--- Makes a GuiObject draggable using input events only while dragging.
--- @param target GuiObject Object whose Position is updated.
--- @param options dragOptions? Drag behavior.
--- @return dragController Owned drag controller.
function module.bind(target: GuiObject, options: dragOptions?): dragController
	local settings: dragOptions

	if options then
		settings = options
	else
		settings = {}
	end

	local handle = settings.handle or target
	local axis = settings.axis or "Both"
	local enabled = settings.enabled ~= false

	local isDeleted = false

	local activeInput: InputObject? = nil

	local startAbsolutePosition = target.AbsolutePosition
	local startInputPosition = Vector2.zero
	local startPosition = target.Position

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

	local function stopDrag()
		if not activeInput then
			return
		end

		activeInput = nil

		disconnectMove()
	end

	--——————————————————————————————————————————————————————————————————--

	local function getDragOffset(input: InputObject): Vector2
		local inputPosition = getInputPosition(input)
		local offset = inputPosition - startInputPosition

		if axis == "X" then
			return Vector2.new(offset.X, 0)
		end

		if axis == "Y" then
			return Vector2.new(0, offset.Y)
		end

		return offset
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

		local offset = getDragOffset(input)

		if settings.clampToParent == true then
			offset = clampDelta(target, startAbsolutePosition, offset)
		end

		local nextPosition = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + offset.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + offset.Y
		)

		if target.Position == nextPosition then
			return
		end

		target.Position = nextPosition

		local onChanged = settings.onChanged

		if onChanged then
			onChanged(nextPosition)
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

		if not isDragInput(input) then
			return
		end

		activeInput = input

		startAbsolutePosition = target.AbsolutePosition
		startInputPosition = getInputPosition(input)
		startPosition = target.Position

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

		stopDrag()
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

		stopDrag()

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

		stopDrag()

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
