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

export type Placement = "Bottom" | "Left" | "Right" | "Top"

export type PopoverOptions = {
	clampToViewport: boolean?,
	offset: number?,
	placement: Placement?,
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
	placementValue: Placement,
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
function module.place(anchor: GuiObject, object: GuiObject, options: PopoverOptions?): UDim2
	local clampToViewport = true
	local offset = 8
	local placementValue: Placement = "Bottom"

	if options then
		if options.clampToViewport ~= nil then
			clampToViewport = options.clampToViewport
		end

		if options.offset ~= nil then
			offset = options.offset
		end

		if options.placement ~= nil then
			placementValue = options.placement
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


-- Canonical public API names (discoverable directly from Luau).
export type PopoverPlacement = Placement

return module
