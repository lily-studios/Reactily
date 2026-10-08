--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local interactionModule = require(script.Parent.interaction)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- Binds a hover style and automatically restores the original Roblox property values.
--- @param object GuiObject Target UI object.
--- @param style interactionStyle Properties applied while hovered.
--- @return interactionController Owned hover controller.
function module.bind(
	object: GuiObject,
	style: interactionModule.interactionStyle
): interactionModule.interactionController
	local normal: interactionModule.interactionStyle = {}
	local target = object :: any

	for propertyName in style do
		normal[propertyName] = target[propertyName]
	end

	return interactionModule.bind(object, {
		hover = style,
		normal = normal,
	})
end

--————————————————————————————————————————————————————————————————————--

return module
