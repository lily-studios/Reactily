--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)
local hostConfigModule = require(script.Parent.Parent.runtime.hostConfig)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType modalOptions
export type modalOptions = {
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	closeOnBackground: boolean?,
	Name: string?,
	onClose: (() -> ())?,
	ZIndex: number?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a full-screen modal overlay element around children.
--- @param options modalOptions? Overlay options.
--- @param children {any} Modal content.
--- @return element Modal overlay element.
function module.create(options: modalOptions?, children: { any }): elementModule.element
	local backgroundColor3 = Color3.new(0, 0, 0)
	local backgroundTransparency = 0.4
	local closeOnBackground = true
	local name = "Modal"
	local onClose: (() -> ())? = nil
	local zIndex = 100

	if options then
		if options.BackgroundColor3 ~= nil then
			backgroundColor3 = options.BackgroundColor3
		end

		if options.BackgroundTransparency ~= nil then
			backgroundTransparency = options.BackgroundTransparency
		end

		if options.closeOnBackground ~= nil then
			closeOnBackground = options.closeOnBackground
		end

		if options.Name ~= nil then
			name = options.Name
		end

		if options.onClose ~= nil then
			onClose = options.onClose
		end

		if options.ZIndex ~= nil then
			zIndex = options.ZIndex
		end
	end

	local props: elementModule.textButtonProps = {
		AutoButtonColor = false,
		BackgroundColor3 = backgroundColor3,
		BackgroundTransparency = backgroundTransparency,
		Modal = true,
		Name = name,
		Size = UDim2.fromScale(1, 1),
		Text = "",
		ZIndex = zIndex,
	}

	if closeOnBackground then
		if onClose then
			(props :: any)[hostConfigModule.Event.Activated] = onClose
		end
	end

	return elementModule.createTextButton(props, children)
end

--————————————————————————————————————————————————————————————————————--

return module
