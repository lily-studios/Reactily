--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local animationModule = require(script.Parent.animation)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType MotionOptions
export type motionOptions = {
	Delay: number?,
	Direction: Enum.EasingDirection?,
	Duration: number?,
	RepeatCount: number?,
	Reverses: boolean?,
	Style: Enum.EasingStyle?,
}

--————————————————————————————————————————————————————————————————————--

local function resolve(options: motionOptions?): animationModule.tweenOptions
	local delayTime: number? = nil
	local easingDirection: Enum.EasingDirection? = nil
	local easingStyle: Enum.EasingStyle? = nil
	local repeatCount: number? = nil
	local reverses: boolean? = nil
	local time = 0.2

	if options then
		if options.Delay ~= nil then
			delayTime = options.Delay
		end

		if options.Direction ~= nil then
			easingDirection = options.Direction
		end

		if options.Duration ~= nil then
			time = options.Duration
		end

		if options.RepeatCount ~= nil then
			repeatCount = options.RepeatCount
		end

		if options.Reverses ~= nil then
			reverses = options.Reverses
		end

		if options.Style ~= nil then
			easingStyle = options.Style
		end
	end

	assert(time >= 0, "[Reactily] Motion duration cannot be negative.")

	if delayTime ~= nil then
		assert(delayTime >= 0, "[Reactily] Motion delay cannot be negative.")
	end

	if repeatCount ~= nil then
		assert(repeatCount >= -1, "[Reactily] Motion repeatCount cannot be less than -1.")
	end

	return {
		DelayTime = delayTime,
		EasingDirection = easingDirection,
		EasingStyle = easingStyle,
		RepeatCount = repeatCount,
		Reverses = reverses,
		Time = time,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily animation without playing it.
--- @param instance Instance Roblox target.
--- @param goals {[string]: any} Roblox property goals.
--- @param options motionOptions? Motion configuration.
--- @return animation Owned animation.
function module.Create(instance: Instance, goals: { [string]: any }, options: motionOptions?): animationModule.animation
	return animationModule.Tween(instance, goals, resolve(options))
end

--————————————————————————————————————————————————————————————————————--

--- Plays a Roblox property animation immediately.
--- @param instance Instance Roblox target.
--- @param goals {[string]: any} Roblox property goals.
--- @param options motionOptions? Motion configuration.
--- @return animation Owned running animation.
function module.Play(instance: Instance, goals: { [string]: any }, options: motionOptions?): animationModule.animation
	return animationModule.Play(instance, goals, resolve(options))
end

--————————————————————————————————————————————————————————————————————--

return module
