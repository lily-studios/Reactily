--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local textService = game:GetService("TextService")

--————————————————————————————————————————————————————————————————————--

local popoverModule = require(script.Parent.popover)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType tooltipOptions
export type tooltipOptions = {
	BackgroundColor3: Color3?,
	delay: number?,
	Font: Enum.Font?,
	offset: number?,
	placement: popoverModule.placement?,
	TextColor3: Color3?,
	TextSize: number?,
}

--- @reactilyType tooltip
export type tooltip = {
	delete: () -> boolean,
	hide: () -> (),
	isDeleted: () -> boolean,
	show: () -> (),
}

--————————————————————————————————————————————————————————————————————--

local function calculateSize(text: string, font: Enum.Font, textSize: number): UDim2
	local padding = 8

	local textBounds = textService:GetTextSize(text, textSize, font, Vector2.new(500, 500))

	return UDim2.fromOffset(textBounds.X + padding * 2, textBounds.Y + padding)
end

--————————————————————————————————————————————————————————————————————--

--- Attaches an owned tooltip to a GuiObject.
--- @param parent Instance Parent for the tooltip ScreenGui.
--- @param target GuiObject Hover target.
--- @param text string Tooltip text.
--- @param options tooltipOptions? Tooltip appearance and placement.
--- @return tooltip Owned tooltip controller.
function module.attach(parent: Instance, target: GuiObject, text: string, options: tooltipOptions?): tooltip
	local backgroundColor3 = Color3.fromRGB(24, 24, 24)
	local delaySeconds = 0.35
	local font = Enum.Font.Gotham
	local offset = 8
	local placement: popoverModule.placement = "Bottom"
	local textColor3 = Color3.new(1, 1, 1)
	local textSize = 14

	if options then
		if options.BackgroundColor3 ~= nil then
			backgroundColor3 = options.BackgroundColor3
		end

		if options.delay ~= nil then
			delaySeconds = options.delay
		end

		if options.Font ~= nil then
			font = options.Font
		end

		if options.offset ~= nil then
			offset = options.offset
		end

		if options.placement ~= nil then
			placement = options.placement
		end

		if options.TextColor3 ~= nil then
			textColor3 = options.TextColor3
		end

		if options.TextSize ~= nil then
			textSize = options.TextSize
		end
	end

	assert(delaySeconds >= 0, "Reactily tooltip delay cannot be negative.")
	assert(offset >= 0, "Reactily tooltip offset cannot be negative.")
	assert(textSize >= 0, "Reactily tooltip TextSize cannot be negative.")

	local screenGui = Instance.new("ScreenGui")

	screenGui.Name = "ReactilyTooltip"
	screenGui.DisplayOrder = 10000
	screenGui.IgnoreGuiInset = true
	screenGui.ResetOnSpawn = false
	screenGui.Parent = parent

	local label = Instance.new("TextLabel")

	label.Name = "Tooltip"
	label.AutomaticSize = Enum.AutomaticSize.None
	label.BackgroundColor3 = backgroundColor3
	label.BorderSizePixel = 0
	label.Font = font
	label.Size = calculateSize(text, font, textSize)
	label.Text = text
	label.TextColor3 = textColor3
	label.TextSize = textSize
	label.Visible = false
	label.ZIndex = 1
	label.Parent = screenGui

	local generation = 0
	local isDeleted = false

	local delayedThread: thread? = nil

	--——————————————————————————————————————————————————————————————————--

	local function cancelDelay()
		local threadValue = delayedThread

		if not threadValue then
			return
		end

		delayedThread = nil

		if coroutine.status(threadValue) == "dead" then
			return
		end

		task.cancel(threadValue)
	end

	--——————————————————————————————————————————————————————————————————--

	local function positionTooltip()
		popoverModule.place(target, label, {
			offset = offset,
			placement = placement,
		})
	end

	--——————————————————————————————————————————————————————————————————--

	local function show()
		if isDeleted then
			return
		end

		generation += 1

		local currentGeneration = generation

		cancelDelay()

		delayedThread = task.delay(delaySeconds, function()
			delayedThread = nil

			if isDeleted then
				return
			end

			if currentGeneration ~= generation then
				return
			end

			positionTooltip()

			if label.Visible then
				return
			end

			label.Visible = true
		end)
	end

	--——————————————————————————————————————————————————————————————————--

	local function hide()
		if isDeleted then
			return
		end

		generation += 1

		cancelDelay()

		if not label.Visible then
			return
		end

		label.Visible = false
	end

	--——————————————————————————————————————————————————————————————————--

	local enteredConnection = target.MouseEnter:Connect(show)
	local leftConnection = target.MouseLeave:Connect(hide)

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		generation += 1

		cancelDelay()

		enteredConnection:Disconnect()
		leftConnection:Disconnect()

		screenGui:Destroy()

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		delete = delete,
		hide = hide,
		isDeleted = getIsDeleted,
		show = show,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
