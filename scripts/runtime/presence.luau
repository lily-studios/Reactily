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

export type PresenceOptions = {
	enter: { [string]: any }?,
	exit: { [string]: any }?,
	motion: motionModule.MotionOptions?,
}

export type Presence = {
	delete: () -> boolean,
	hide: () -> boolean,
	isDeleted: () -> boolean,
	isVisible: () -> boolean,
	show: () -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates an enter/exit visibility controller for a GuiObject.
--- @param object GuiObject Target object.
--- @param options presenceOptions? Enter and exit property goals.
--- @return presence Owned presence controller.
function module.create(object: GuiObject, options: PresenceOptions?): Presence
	local enterGoals: { [string]: any }? = nil
	local exitGoals: { [string]: any }? = nil
	local motionOptions: motionModule.MotionOptions? = nil

	if options then
		if options.enter ~= nil then
			enterGoals = options.enter
		end

		if options.exit ~= nil then
			exitGoals = options.exit
		end

		if options.motion ~= nil then
			motionOptions = options.motion
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

		animationValue.delete()
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

		local animationValue = motionModule.play(object, enterGoals, motionOptions)

		currentAnimation = animationValue

		animationValue.onCompleted(function()
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

			animationValue.delete()
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

		local animationValue = motionModule.play(object, exitGoals, motionOptions)

		currentAnimation = animationValue

		animationValue.onCompleted(function()
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

			animationValue.delete()
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
		delete = delete,
		hide = hide,
		isDeleted = getIsDeleted,
		isVisible = getIsVisible,
		show = show,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
