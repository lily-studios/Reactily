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

export type playable = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	onCompleted: ((callback: (playbackState: Enum.PlaybackState) -> ()) -> RBXScriptConnection)?,
	play: () -> (),
}

export type animationGroup = {
	cancel: () -> boolean,
	delete: () -> boolean,
	isDeleted: () -> boolean,
	play: () -> (),
}

--————————————————————————————————————————————————————————————————————--

local function createGroup(animations: { playable }, sequential: boolean): animationGroup
	local completionConnections: { RBXScriptConnection } = {}

	local isDeleted = false
	local isPlaying = false

	local function disconnectCompletions()
		for _, connection in completionConnections do
			if not connection.Connected then
				continue
			end

			connection:Disconnect()
		end

		table.clear(completionConnections)
	end

	local function cancel(): boolean
		if isDeleted then
			return false
		end
		if not isPlaying then
			return false
		end

		isPlaying = false
		disconnectCompletions()

		for _, animation in animations do
			animation.cancel()
		end

		return true
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		cancel()
		isDeleted = true

		for _, animation in animations do
			animation.delete()
		end

		table.clear(animations)

		return true
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function playParallel()
		isPlaying = true

		local remaining = #animations

		local function completeOne()
			remaining -= 1
			if remaining > 0 then
				return
			end

			isPlaying = false
			disconnectCompletions()
		end

		for _, animation in animations do
			local onCompleted = animation.onCompleted

			if not onCompleted then
				animation.play()
				completeOne()
				continue
			end

			local connection = onCompleted(function()
				completeOne()
			end)

			completionConnections[#completionConnections + 1] = connection
			animation.play()
		end
	end

	local function playSequential()
		isPlaying = true

		local index = 0

		local function playNext()
			if not isPlaying then
				return
			end
			if isDeleted then
				return
			end

			index += 1

			local animation = animations[index]

			if not animation then
				isPlaying = false
				disconnectCompletions()
				return
			end

			local onCompleted = animation.onCompleted

			if not onCompleted then
				animation.play()
				playNext()
				return
			end

			local connectionReference: RBXScriptConnection? = nil

			local connection = onCompleted(function()
				local activeConnection = connectionReference

				if activeConnection and activeConnection.Connected then
					activeConnection:Disconnect()
				end

				playNext()
			end)

			connectionReference = connection
			completionConnections[#completionConnections + 1] = connection

			animation.play()
		end

		playNext()
	end

	local function play()
		assert(not isDeleted, "Reactily animation group is deleted.")

		if isPlaying then
			return
		end
		if #animations == 0 then
			return
		end

		disconnectCompletions()

		if sequential then
			playSequential()
			return
		end

		playParallel()
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
function module.delay(seconds: number): playable
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
function module.parallel(animations: { playable }): animationGroup
	return createGroup(table.clone(animations), false)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a group that plays each animation after the previous one completes.
--- @param animations {playable} Owned animations to run sequentially.
--- @return animationGroup Sequential animation group.
function module.sequence(animations: { playable }): animationGroup
	return createGroup(table.clone(animations), true)
end

--————————————————————————————————————————————————————————————————————--

return module
