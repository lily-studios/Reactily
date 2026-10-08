--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local motionModule = require(script.Parent.motion)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType PresenceOptions
export type presenceOptions = {
	Enter: { [string]: any }?,
	Exit: { [string]: any }?,
	Motion: motionModule.motionOptions?,
}

--- @reactilyType Presence
export type presence = {
	Delete: () -> boolean,
	Hide: () -> boolean,
	IsDeleted: () -> boolean,
	IsVisible: () -> boolean,
	Show: () -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates an enter/exit visibility controller for a GuiObject.
--- @param object GuiObject Target object.
--- @param options presenceOptions? Enter and exit property goals.
--- @return presence Owned presence controller.
function module.Create(object: GuiObject, options: presenceOptions?): presence
	local enterGoals: { [string]: any }? = nil
	local exitGoals: { [string]: any }? = nil
	local motionOptions: motionModule.motionOptions? = nil

	if options then
		if options.Enter ~= nil then
			enterGoals = options.Enter
		end

		if options.Exit ~= nil then
			exitGoals = options.Exit
		end

		if options.Motion ~= nil then
			motionOptions = options.Motion
		end
	end

	local currentAnimation: any = nil
	local generation = 0
	local isDeleted = false
	local visible = object.Visible

	--——————————————————————————————————————————————————————————————————--

	local function clearAnimation()
		local animationValue = currentAnimation

		if not animationValue then
			return
		end

		currentAnimation = nil

		animationValue.Delete()
	end

	--——————————————————————————————————————————————————————————————————--

	local function setVisible(nextVisible: boolean)
		if object.Visible == nextVisible then
			return
		end

		object.Visible = nextVisible
	end

	--——————————————————————————————————————————————————————————————————--

	local function show(): boolean
		if isDeleted then
			return false
		end

		if visible then
			return false
		end

		generation += 1
		visible = true

		clearAnimation()

		setVisible(true)

		if not enterGoals then
			return true
		end

		local localGeneration = generation

		local animationValue = motionModule.Play(object, enterGoals, motionOptions)

		currentAnimation = animationValue

		animationValue.OnCompleted(function()
			if isDeleted then
				return
			end

			if not visible then
				return
			end

			if localGeneration ~= generation then
				return
			end

			if currentAnimation ~= animationValue then
				return
			end

			currentAnimation = nil

			animationValue.Delete()
		end)

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function hide(): boolean
		if isDeleted then
			return false
		end

		if not visible then
			return false
		end

		generation += 1

		local localGeneration = generation

		visible = false

		clearAnimation()

		if not exitGoals then
			setVisible(false)

			return true
		end

		local animationValue = motionModule.Play(object, exitGoals, motionOptions)

		currentAnimation = animationValue

		animationValue.OnCompleted(function()
			if isDeleted then
				return
			end

			if visible then
				return
			end

			if localGeneration ~= generation then
				return
			end

			if currentAnimation ~= animationValue then
				return
			end

			currentAnimation = nil

			setVisible(false)

			animationValue.Delete()
		end)

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		generation += 1

		clearAnimation()

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsVisible(): boolean
		if isDeleted then
			return false
		end

		return visible
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		Delete = delete,
		Hide = hide,
		IsDeleted = getIsDeleted,
		IsVisible = getIsVisible,
		Show = show,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
