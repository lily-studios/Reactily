--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type Playable = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: ((callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection)?,
	play: () -> (),
}

export type AnimationGroup = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	play: () -> (),
}

--————————————————————————————————————————————————————————————————————--

local function createGroup(animations: { Playable }, sequential: boolean): AnimationGroup
	local completionConnections: { RBXScriptConnection } = {}
	local isDeleted = false
	local isPlaying = false
	local generation = 0

	local function disconnectCompletions()
		local connections = table.clone(completionConnections)
		table.clear(completionConnections)
		for _, connection in connections do
			connection:Disconnect()
		end
	end

	local function isCurrent(version: number): boolean
		return not isDeleted and isPlaying and generation == version
	end

	local function cancel(): boolean
		if isDeleted or not isPlaying then
			return false
		end
		isPlaying = false
		generation += 1
		local version = generation
		disconnectCompletions()
		for _, animation in animations do
			if generation ~= version then
				break
			end
			animation.cancel()
		end
		return true
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end
		local wasPlaying = isPlaying
		-- Mark first: cancellation/completion callbacks can reenter deletion.
		isDeleted = true
		isPlaying = false
		generation += 1
		disconnectCompletions()
		local retiring = table.clone(animations)
		table.clear(animations)
		for _, animation in retiring do
			if wasPlaying then
				local cancelled, cancelFailure = pcall(animation.cancel)
				if not cancelled then
					warn(`Reactily animation group cancellation failed: {cancelFailure}`)
				end
			end
			local success, failure = pcall(function(): boolean
				animation.delete()
				return true
			end)
			if not success then
				warn(`Reactily animation group cleanup failed: {failure}`)
			end
		end
		return true
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function playParallel()
		local version = generation
		local remaining = #animations
		local function completeOne()
			if not isCurrent(version) then
				return
			end
			remaining -= 1
			if remaining == 0 then
				isPlaying = false
				disconnectCompletions()
			end
		end
		for _, animation in animations do
			if not isCurrent(version) then
				break
			end
			local onCompleted = animation.onCompleted
			if not onCompleted then
				animation.play()
				completeOne()
				continue
			end
			local completed = false
			local connection = onCompleted(function()
				if completed then
					return
				end
				completed = true
				completeOne()
			end)
			if completed or not isCurrent(version) then
				connection:Disconnect()
			else
				completionConnections[#completionConnections + 1] = connection
				animation.play()
			end
		end
	end

	local function playSequential()
		local version = generation
		local index = 0
		local advancing = false
		local advanceRequested = false
		local function playNext()
			if not isCurrent(version) then
				return
			end
			if advancing then
				advanceRequested = true
				return
			end
			advancing = true
			repeat
				advanceRequested = false
				index += 1
				local animation = animations[index]
				if not animation then
					isPlaying = false
					disconnectCompletions()
					break
				end
				local onCompleted = animation.onCompleted
				if not onCompleted then
					animation.play()
					advanceRequested = true
					continue
				end
				local completed = false
				local connectionReference: RBXScriptConnection? = nil
				local connection = onCompleted(function()
					if completed or not isCurrent(version) then
						return
					end
					completed = true
					if connectionReference then
						connectionReference:Disconnect()
					end
					playNext()
				end)
				connectionReference = connection
				if completed or not isCurrent(version) then
					connection:Disconnect()
				else
					completionConnections[#completionConnections + 1] = connection
					animation.play()
				end
			until not advanceRequested or not isCurrent(version)
			advancing = false
		end
		playNext()
	end

	local function play()
		assert(not isDeleted, "Reactily animation group is deleted.")
		if isPlaying or #animations == 0 then
			return
		end
		disconnectCompletions()
		generation += 1
		local version = generation
		isPlaying = true
		local success, failure = pcall(function(): boolean
			if sequential then
				playSequential()
			else
				playParallel()
			end
			return true
		end)
		if not success then
			if generation == version then
				isPlaying = false
				disconnectCompletions()
			end
			error(failure, 0)
		end
	end

	return {
		cancel = cancel,
		delete = delete,
		isDeleted = getIsDeleted,
		play = play,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a one-shot delay step compatible with Reactily animation sequences.
--- @param seconds number Delay duration in seconds.
--- @return playable Delay step.
function module.delay(seconds: number): Playable
	assert(seconds >= 0, "Reactily animation delay must be non-negative.")

	local completed = Instance.new("BindableEvent")

	local isDeleted = false
	local generation = 0
	local thread: thread? = nil

	local function cancel(): boolean
		if isDeleted then
			return false
		end
		if not thread then
			return false
		end

		generation += 1

		local current = thread
		thread = nil

		if coroutine.status(current) ~= "dead" then
			task.cancel(current)
		end

		return true
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		cancel()
		isDeleted = true
		completed:Destroy()

		return true
	end

	local function play()
		assert(not isDeleted, "Reactily animation delay is deleted.")

		cancel()
		generation += 1

		local currentGeneration = generation

		thread = task.delay(seconds, function()
			if isDeleted then
				return
			end
			if currentGeneration ~= generation then
				return
			end

			thread = nil
			completed:Fire(Enum.PlaybackState.Completed)
		end)
	end

	return {
		cancel = cancel,
		delete = delete,

		isDeleted = function(): boolean
			return isDeleted
		end,

		onCompleted = function(callback: (playbackState: Enum.PlaybackState) -> ()): RBXScriptConnection
			assert(not isDeleted, "Reactily animation delay is deleted.")

			return completed.Event:Connect(callback)
		end,

		play = play,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a group that starts every animation together.
--- @param animations {playable} Owned animations to run in parallel.
--- @return animationGroup Parallel animation group.
function module.parallel(animations: { Playable }): AnimationGroup
	return createGroup(table.clone(animations), false)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a group that plays each animation after the previous one completes.
--- @param animations {playable} Owned animations to run sequentially.
--- @return animationGroup Sequential animation group.
function module.sequence(animations: { Playable }): AnimationGroup
	return createGroup(table.clone(animations), true)
end

--————————————————————————————————————————————————————————————————————--

-- Canonical public API names (discoverable directly from Luau).
module.createAnimationDelay = module.delay
module.parallelAnimations = module.parallel
module.sequenceAnimations = module.sequence
export type AnimationPlayable = Playable

return module
