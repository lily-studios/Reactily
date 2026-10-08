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

--- @reactilyType interactionStyle
export type interactionStyle = { [string]: any }

--- @reactilyType interactionOptions
export type interactionOptions = {
	disabled: interactionStyle?,
	focused: interactionStyle?,
	hover: interactionStyle?,
	normal: interactionStyle?,
	pressed: interactionStyle?,
}

--- @reactilyType interactionController
export type interactionController = {
	delete: () -> boolean,
	isDeleted: () -> boolean,
	refresh: () -> (),
	setDisabled: (disabled: boolean) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function applyStyle(object: GuiObject, style: interactionStyle?)
	if not style then
		return
	end

	local target = object :: any

	for propertyName, value in style do
		if target[propertyName] == value then
			continue
		end

		target[propertyName] = value
	end
end

--————————————————————————————————————————————————————————————————————--

--- Binds hover, pressed, focused, and disabled visual states to a GuiObject.
--- @param object GuiObject Target UI object.
--- @param options interactionOptions Visual-state definitions.
--- @return interactionController Owned interaction controller.
function module.bind(object: GuiObject, options: interactionOptions): interactionController
	local connections: { RBXScriptConnection } = {}
	local disabled = false
	local focused = false
	local hovered = false
	local isDeleted = false
	local pressed = false

	local function refresh()
		if isDeleted then
			return
		end

		applyStyle(object, options.normal)

		if disabled then
			applyStyle(object, options.disabled)
			return
		end
		if pressed then
			applyStyle(object, options.pressed)
			return
		end
		if focused then
			applyStyle(object, options.focused)
			return
		end
		if hovered then
			applyStyle(object, options.hover)
		end
	end

	connections[#connections + 1] = object.MouseEnter:Connect(function()
		hovered = true
		refresh()
	end)
	connections[#connections + 1] = object.MouseLeave:Connect(function()
		hovered = false
		pressed = false
		refresh()
	end)
	connections[#connections + 1] = object.InputBegan:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		pressed = true
		refresh()
	end)
	connections[#connections + 1] = object.InputEnded:Connect(function(input: InputObject)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end

		pressed = false
		refresh()
	end)
	connections[#connections + 1] = object.SelectionGained:Connect(function()
		focused = true
		refresh()
	end)
	connections[#connections + 1] = object.SelectionLost:Connect(function()
		focused = false
		refresh()
	end)

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)
		return true
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function setDisabled(nextDisabled: boolean): boolean
		if isDeleted or disabled == nextDisabled then
			return false
		end

		disabled = nextDisabled
		pressed = false
		refresh()
		return true
	end

	refresh()

	return {
		delete = delete,
		isDeleted = getIsDeleted,
		refresh = refresh,
		setDisabled = setDisabled,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
