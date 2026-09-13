--!strict

-- provides TweenService-backed Reactily animation helpers

local tweenService = game:GetService("TweenService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type animation = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: (callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection,
	play: () -> (),
	tween: Tween,
}

export type tweenOptions = {
	delayTime: number?,
	easingDirection: Enum.EasingDirection?,
	easingStyle: Enum.EasingStyle?,
	repeatCount: number?,
	reverses: boolean?,
	time: number,
}

--————————————————————————————————————————————————————————————————————--

local function resolveTweenInfo(options: tweenOptions): TweenInfo
	assert(options.time >= 0, "Reactily tween time must be non-negative.")

	local delayTime = 0
	local easingDirection = Enum.EasingDirection.Out
	local easingStyle = Enum.EasingStyle.Quad
	local repeatCount = 0
	local reverses = false

	if options.delayTime ~= nil then
		delayTime = options.delayTime
	end

	if options.easingDirection ~= nil then
		easingDirection = options.easingDirection
	end

	if options.easingStyle ~= nil then
		easingStyle = options.easingStyle
	end

	if options.repeatCount ~= nil then
		repeatCount = options.repeatCount
	end

	if options.reverses ~= nil then
		reverses = options.reverses
	end

	return TweenInfo.new(
		options.time,
		easingStyle,
		easingDirection,
		repeatCount,
		reverses,
		delayTime
	)
end

--————————————————————————————————————————————————————————————————————--

--- Creates and immediately plays a TweenService-backed animation.
--- @param instance Instance Instance whose properties will be animated.
--- @param goals {[string]: any} Target property values passed to TweenService.
--- @param options tweenOptions Tween duration and optional playback settings.
--- @return animation The active Reactily animation.
function module.play(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	local animationValue = module.tween(instance, goals, options)

	animationValue.play()

	return animationValue
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TweenService-backed animation without playing it automatically.
--- @param instance Instance Instance whose properties will be animated.
--- @param goals {[string]: any} Target property values passed to TweenService.
--- @param options tweenOptions Tween duration and optional playback settings.
--- @return animation A new Reactily animation.
function module.tween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
	local completionConnections: {RBXScriptConnection} = {}
	local isDeleted = false
	local tween = tweenService:Create(instance, resolveTweenInfo(options), goals)

	--- Cancels the current tween playback.
	--- @return boolean Whether the animation was available to cancel.
	local function cancel(): boolean
		if isDeleted then return false end

		tween:Cancel()

		return true
	end

	--- Deletes the animation, disconnects completion listeners, and destroys the Tween.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true

		for _, connection in completionConnections do
			if not connection.Connected then continue end

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

	--- Connects a callback to the underlying Tween completion event.
	--- @param callback (playbackState: Enum.PlaybackState) -> () Callback receiving the final playback state.
	--- @return RBXScriptConnection The Roblox completion connection.
	local function onCompleted(
		callback: (playbackState: Enum.PlaybackState) -> ()
	): RBXScriptConnection
		assert(not isDeleted, "Reactily animation is deleted.")

		local connection = tween.Completed:Connect(callback)

		completionConnections[#completionConnections + 1] = connection

		return connection
	end

	--- Starts or resumes Tween playback.
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

return module