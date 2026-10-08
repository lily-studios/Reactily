--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local guiService = game:GetService("GuiService")

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType SafeAreaInsets
export type insets = {
	Bottom: number,
	Left: number,
	Right: number,
	Top: number,
}

--————————————————————————————————————————————————————————————————————--

--- Returns current Roblox GUI inset values in pixels.
--- @return insets Current safe-area style insets.
function module.GetInsets(): insets
	local topLeft, bottomRight = guiService:GetGuiInset()

	return {
		Bottom = bottomRight.Y,
		Left = topLeft.X,
		Right = bottomRight.X,
		Top = topLeft.Y,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPadding element from current Roblox GUI insets.
--- @return element UIPadding element.
function module.Padding(): elementModule.element
	local value = module.GetInsets()

	return elementModule.CreateUIPadding({
		PaddingBottom = UDim.new(0, value.Bottom),
		PaddingLeft = UDim.new(0, value.Left),
		PaddingRight = UDim.new(0, value.Right),
		PaddingTop = UDim.new(0, value.Top),
	})
end

--————————————————————————————————————————————————————————————————————--

return module
