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

export type Insets = {
	bottom: number,
	left: number,
	right: number,
	top: number,
}

--————————————————————————————————————————————————————————————————————--

--- Returns current Roblox GUI inset values in pixels.
--- @return insets Current safe-area style insets.
function module.getInsets(): Insets
	local topLeft, bottomRight = guiService:GetGuiInset()

	return {
		bottom = bottomRight.Y,
		left = topLeft.X,
		right = bottomRight.X,
		top = topLeft.Y,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPadding element from current Roblox GUI insets.
--- @return element UIPadding element.
function module.padding(): elementModule.Element
	local value = module.getInsets()

	return elementModule.createUIPadding({
		PaddingBottom = UDim.new(0, value.bottom),
		PaddingLeft = UDim.new(0, value.left),
		PaddingRight = UDim.new(0, value.right),
		PaddingTop = UDim.new(0, value.top),
	})
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
export type SafeAreaInsets = Insets

return module
