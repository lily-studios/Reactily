--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local workspaceService = game:GetService("Workspace")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType PopoverPlacement
export type placement = "Bottom" | "Left" | "Right" | "Top"

--- @reactilyType PopoverOptions
export type popoverOptions = {
	ClampToViewport: boolean?,
	Offset: number?,
	Placement: placement?,
}

--————————————————————————————————————————————————————————————————————--

local function parentOrigin(object: GuiObject): Vector2
	local parent = object.Parent

	if not parent then
		return Vector2.zero
	end

	if not parent:IsA("GuiObject") then
		return Vector2.zero
	end

	return parent.AbsolutePosition
end

--————————————————————————————————————————————————————————————————————--

local function chooseAbsolutePosition(
	anchor: GuiObject,
	object: GuiObject,
	placementValue: placement,
	offset: number
): Vector2
	local anchorPosition = anchor.AbsolutePosition
	local anchorSize = anchor.AbsoluteSize
	local objectSize = object.AbsoluteSize

	if placementValue == "Top" then
		return Vector2.new(
			anchorPosition.X + (anchorSize.X - objectSize.X) * 0.5,
			anchorPosition.Y - objectSize.Y - offset
		)
	end

	if placementValue == "Left" then
		return Vector2.new(
			anchorPosition.X - objectSize.X - offset,
			anchorPosition.Y + (anchorSize.Y - objectSize.Y) * 0.5
		)
	end

	if placementValue == "Right" then
		return Vector2.new(
			anchorPosition.X + anchorSize.X + offset,
			anchorPosition.Y + (anchorSize.Y - objectSize.Y) * 0.5
		)
	end

	return Vector2.new(anchorPosition.X + (anchorSize.X - objectSize.X) * 0.5, anchorPosition.Y + anchorSize.Y + offset)
end

--————————————————————————————————————————————————————————————————————--

local function clampPositionToViewport(object: GuiObject, position: Vector2): Vector2
	local camera = workspaceService.CurrentCamera

	if not camera then
		return position
	end

	local viewportSize = camera.ViewportSize
	local objectSize = object.AbsoluteSize

	local maximumX = math.max(0, viewportSize.X - objectSize.X)
	local maximumY = math.max(0, viewportSize.Y - objectSize.Y)

	return Vector2.new(math.clamp(position.X, 0, maximumX), math.clamp(position.Y, 0, maximumY))
end

--————————————————————————————————————————————————————————————————————--

--- Positions a popover GuiObject relative to an anchor.
--- @param anchor GuiObject Anchor object.
--- @param object GuiObject Popover object to position.
--- @param options popoverOptions? Placement options.
--- @return UDim2 Applied object Position.
function module.Place(anchor: GuiObject, object: GuiObject, options: popoverOptions?): UDim2
	local clampToViewport = true
	local offset = 8
	local placementValue: placement = "Bottom"

	if options then
		if options.ClampToViewport ~= nil then
			clampToViewport = options.ClampToViewport
		end

		if options.Offset ~= nil then
			offset = options.Offset
		end

		if options.Placement ~= nil then
			placementValue = options.Placement
		end
	end

	local absolutePosition = chooseAbsolutePosition(anchor, object, placementValue, offset)

	if clampToViewport then
		absolutePosition = clampPositionToViewport(object, absolutePosition)
	end

	local localPosition = absolutePosition - parentOrigin(object)

	local nextPosition = UDim2.fromOffset(localPosition.X, localPosition.Y)

	if object.Position == nextPosition then
		return nextPosition
	end

	object.Position = nextPosition

	return nextPosition
end

--————————————————————————————————————————————————————————————————————--

return module
