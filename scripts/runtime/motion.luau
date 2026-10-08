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

--- @reactilyType motionOptions
export type motionOptions = {
	delay: number?,
	direction: Enum.EasingDirection?,
	duration: number?,
	repeatCount: number?,
	reverses: boolean?,
	style: Enum.EasingStyle?,
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
		if options.delay ~= nil then
			delayTime = options.delay
		end

		if options.direction ~= nil then
			easingDirection = options.direction
		end

		if options.duration ~= nil then
			time = options.duration
		end

		if options.repeatCount ~= nil then
			repeatCount = options.repeatCount
		end

		if options.reverses ~= nil then
			reverses = options.reverses
		end

		if options.style ~= nil then
			easingStyle = options.style
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
		delayTime = delayTime,
		easingDirection = easingDirection,
		easingStyle = easingStyle,
		repeatCount = repeatCount,
		reverses = reverses,
		time = time,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily animation without playing it.
--- @param instance Instance Roblox target.
--- @param goals {[string]: any} Roblox property goals.
--- @param options motionOptions? Motion configuration.
--- @return animation Owned animation.
function module.create(instance: Instance, goals: { [string]: any }, options: motionOptions?): animationModule.animation
	return animationModule.tween(instance, goals, resolve(options))
end

--————————————————————————————————————————————————————————————————————--

--- Plays a Roblox property animation immediately.
--- @param instance Instance Roblox target.
--- @param goals {[string]: any} Roblox property goals.
--- @param options motionOptions? Motion configuration.
--- @return animation Owned running animation.
function module.play(instance: Instance, goals: { [string]: any }, options: motionOptions?): animationModule.animation
	return animationModule.play(instance, goals, resolve(options))
end

--————————————————————————————————————————————————————————————————————--

return module
