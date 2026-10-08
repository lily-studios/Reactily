--[[
  Reactily · Lily Studios
  Copyright (c) Lily Studios and contributors.
  Licensed under the MIT License.
  See LICENSE in the repository root for full terms.
]]

--!strict

local tweenService = game:GetService("TweenService")

local module = {}

--- Configuration options for Roblox-native view transitions.
--- @field duration number? Transition duration in seconds.
--- @field easingDirection Enum.EasingDirection? Direction of the easing curve.
--- @field easingStyle Enum.EasingStyle? Easing style applied to transitions.
--- @field enterFrom {[string]: any}? Initial property values used for enter animations.
export type options = {
	Duration: number?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	EnterFrom: { [string]: any }?,
}

--- Captured visual properties indexed by Roblox Instance.
export type snapshot = { [Instance]: { [string]: any } }

local trackedProperties = table.freeze({
	"Position",
	"Size",
	"Rotation",
	"BackgroundTransparency",
	"TextTransparency",
	"TextStrokeTransparency",
	"ImageTransparency",
	"GroupTransparency",
})

--- Safely reads a property from a Roblox Instance.
--- @param instance Instance Instance containing the property.
--- @param propertyName string Name of the property to read.
--- @return boolean Whether the property was read successfully.
--- @return any Property value or captured error.
local function readProperty(instance: Instance, propertyName: string): (boolean, any)
	local target = instance :: any
	return pcall(function(): any
		return target[propertyName]
	end)
end

--- Safely assigns a property value to a Roblox Instance.
--- @param instance Instance Instance containing the property.
--- @param propertyName string Name of the property to update.
--- @param value any Value to assign to the property.
local function writeProperty(instance: Instance, propertyName: string, value: any)
	local target = instance :: any
	pcall(function()
		target[propertyName] = value
	end)
end

--————————————————————————————————————————————————————————————————————--

--- Captures tweenable visual state for a group of host instances.
--- @param instances {Instance} Host instances whose visual properties should be captured.
--- @return snapshot Captured property values indexed by Instance.
function module.Capture(instances: { Instance }): snapshot
	local output: snapshot = {}
	for _, instance in instances do
		local properties: { [string]: any } = {}
		for _, propertyName in trackedProperties do
			local success, value = readProperty(instance, propertyName)
			if success then
				properties[propertyName] = value
			end
		end
		if next(properties) ~= nil then
			output[instance] = properties
		end
	end
	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates TweenInfo using the supplied transition configuration.
--- @param config options? Optional duration and easing configuration.
--- @return TweenInfo Tween information with configured or default values.
local function createTweenInfo(config: options?): TweenInfo
	local duration = if config and config.Duration ~= nil then math.max(config.Duration, 0) else 0.2
	local easingStyle = if config and config.EasingStyle then config.EasingStyle else Enum.EasingStyle.Quad
	local easingDirection = if config and config.EasingDirection
		then config.EasingDirection
		else Enum.EasingDirection.Out
	return TweenInfo.new(duration, easingStyle, easingDirection)
end

--- Animates changed properties from a previous snapshot to current values.
--- The current values are treated as the final goals.
--- @param before snapshot Previously captured visual properties.
--- @param instances {Instance} Host instances whose changed properties should be animated.
--- @param config options? Optional transition duration and easing configuration.
--- @return {Tween} Created and started tween animations.
function module.PlayUpdate(before: snapshot, instances: { Instance }, config: options?): { Tween }
	local tweens: { Tween } = {}
	local tweenInfo = createTweenInfo(config)

	for _, instance in instances do
		local previous = before[instance]
		if not previous then
			continue
		end

		local goals: { [string]: any } = {}
		for propertyName, previousValue in previous do
			local success, currentValue = readProperty(instance, propertyName)
			if success and currentValue ~= previousValue then
				goals[propertyName] = currentValue
				writeProperty(instance, propertyName, previousValue)
			end
		end

		if next(goals) == nil then
			continue
		end

		local success, tweenValue = pcall(function(): Tween
			return tweenService:Create(instance, tweenInfo, goals)
		end)
		if success then
			local tween = tweenValue :: Tween
			tweens[#tweens + 1] = tween
			tween:Play()
		end
	end

	return tweens
end

--- Plays an enter transition using an optional property map.
--- @param instances {Instance} Host instances entering the rendered subtree.
--- @param config options? Optional transition configuration containing initial property values.
--- @return {Tween} Created and started enter animations, or an empty array when disabled.
function module.PlayEnter(instances: { Instance }, config: options?): { Tween }
	if not config or not config.EnterFrom or next(config.EnterFrom) == nil then
		return {}
	end

	local tweenInfo = createTweenInfo(config)
	local tweens: { Tween } = {}

	for _, instance in instances do
		local goals: { [string]: any } = {}
		for propertyName, fromValue in config.EnterFrom do
			local success, currentValue = readProperty(instance, propertyName)
			if success then
				goals[propertyName] = currentValue
				writeProperty(instance, propertyName, fromValue)
			end
		end

		if next(goals) == nil then
			continue
		end

		local success, tweenValue = pcall(function(): Tween
			return tweenService:Create(instance, tweenInfo, goals)
		end)
		if success then
			local tween = tweenValue :: Tween
			tweens[#tweens + 1] = tween
			tween:Play()
		end
	end

	return tweens
end

--————————————————————————————————————————————————————————————————————--

--- Cancels all active tweens and clears their collection.
--- @param tweens {Tween} Tween animations to cancel and remove from the collection.
function module.Cancel(tweens: { Tween })
	for _, tween in tweens do
		pcall(function()
			tween:Cancel()
		end)
	end
	table.clear(tweens)
end

--————————————————————————————————————————————————————————————————————--

return module
