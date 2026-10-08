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

local function clampCanvasPosition(frame: ScrollingFrame, position: Vector2): Vector2
	local maximum = Vector2.new(
		math.max(0, frame.AbsoluteCanvasSize.X - frame.AbsoluteWindowSize.X),
		math.max(0, frame.AbsoluteCanvasSize.Y - frame.AbsoluteWindowSize.Y)
	)

	return Vector2.new(math.clamp(position.X, 0, maximum.X), math.clamp(position.Y, 0, maximum.Y))
end

--————————————————————————————————————————————————————————————————————--

--- Scrolls by a pixel delta while clamping to the canvas bounds.
--- @param frame ScrollingFrame Target scrolling frame.
--- @param delta Vector2 Pixel delta.
function module.By(frame: ScrollingFrame, delta: Vector2)
	local nextPosition = clampCanvasPosition(frame, frame.CanvasPosition + delta)
	if frame.CanvasPosition == nextPosition then
		return
	end

	frame.CanvasPosition = nextPosition
end

--————————————————————————————————————————————————————————————————————--

--- Scrolls to the bottom-right canvas limit.
--- @param frame ScrollingFrame Target scrolling frame.
function module.ToBottom(frame: ScrollingFrame)
	local nextPosition = clampCanvasPosition(frame, Vector2.new(math.huge, math.huge))
	if frame.CanvasPosition == nextPosition then
		return
	end

	frame.CanvasPosition = nextPosition
end

--————————————————————————————————————————————————————————————————————--

--- Scrolls until a descendant GuiObject is visible.
--- @param frame ScrollingFrame Target scrolling frame.
--- @param object GuiObject Descendant to reveal.
function module.ToObject(frame: ScrollingFrame, object: GuiObject)
	assert(object:IsDescendantOf(frame), "Reactily.Scroll.toObject target must be a descendant of the ScrollingFrame.")

	local localPosition = object.AbsolutePosition - frame.AbsolutePosition + frame.CanvasPosition
	local nextPosition = clampCanvasPosition(frame, localPosition)

	if frame.CanvasPosition == nextPosition then
		return
	end

	frame.CanvasPosition = nextPosition
end

--————————————————————————————————————————————————————————————————————--

--- Scrolls to the top-left origin.
--- @param frame ScrollingFrame Target scrolling frame.
function module.ToTop(frame: ScrollingFrame)
	if frame.CanvasPosition == Vector2.zero then
		return
	end

	frame.CanvasPosition = Vector2.zero
end

--————————————————————————————————————————————————————————————————————--

return module
