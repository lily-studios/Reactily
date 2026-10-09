--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local tweenService = game:GetService("TweenService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type Animation = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: (callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection,
	play: () -> (),
	tween: Tween,
}

export type TweenOptions = {
	delayTime: number?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	RepeatCount: number?,
	Reverses: boolean?,
	Time: number,
}

--————————————————————————————————————————————————————————————————————--

local function resolveTweenInfo(options: TweenOptions): TweenInfo
	assert(options.Time >= 0, "Reactily tween time must be non-negative.")

	local delayTime = 0
	local easingDirection = Enum.EasingDirection.Out
	local easingStyle = Enum.EasingStyle.Quad
	local repeatCount = 0
	local reverses = false

	if options.delayTime ~= nil then
		delayTime = options.delayTime
	end

	if options.EasingDirection ~= nil then
		easingDirection = options.EasingDirection
	end

	if options.EasingStyle ~= nil then
		easingStyle = options.EasingStyle
	end

	if options.RepeatCount ~= nil then
		repeatCount = options.RepeatCount
	end

	if options.Reverses ~= nil then
		reverses = options.Reverses
	end

	return TweenInfo.new(options.Time, easingStyle, easingDirection, repeatCount, reverses, delayTime)
end

--————————————————————————————————————————————————————————————————————--

--- Creates and immediately plays an owned TweenService animation.
--- @param instance Instance Roblox Instance to animate.
--- @param goals {[string]: any} Property goals passed to TweenService.
--- @param options tweenOptions Tween configuration.
--- @return animation Owned Reactily animation.
function module.play(instance: Instance, goals: { [string]: any }, options: TweenOptions): Animation
	local animationValue = module.tween(instance, goals, options)

	animationValue.play()

	return animationValue
end

--————————————————————————————————————————————————————————————————————--

--- Creates an owned TweenService animation without automatically playing it.
--- @param instance Instance Roblox Instance to animate.
--- @param goals {[string]: any} Property goals passed to TweenService.
--- @param options tweenOptions Tween configuration.
--- @return animation Owned Reactily animation.
function module.tween(instance: Instance, goals: { [string]: any }, options: TweenOptions): Animation
	local completionConnections: { RBXScriptConnection } = {}

	local isDeleted = false
	local tween = tweenService:Create(instance, resolveTweenInfo(options), goals)

	local function cancel(): boolean
		if isDeleted then
			return false
		end

		tween:Cancel()

		return true
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in completionConnections do
			if not connection.Connected then
				continue
			end

			connection:Disconnect()
		end

		table.clear(completionConnections)

		tween:Cancel()
		tween:Destroy()

		return true
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function onCompleted(callback: (playbackState: Enum.PlaybackState) -> ()): RBXScriptConnection
		assert(not isDeleted, "Reactily animation is deleted.")

		local connection = tween.Completed:Connect(callback)

		completionConnections[#completionConnections + 1] = connection

		return connection
	end

	local function play()
		assert(not isDeleted, "Reactily animation is deleted.")

		tween:Play()
	end

	return {
		cancel = cancel,
		delete = delete,
		isDeleted = getIsDeleted,
		onCompleted = onCompleted,
		play = play,
		tween = tween,
	}
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.createTween = module.tween
module.playTween = module.play

return module
