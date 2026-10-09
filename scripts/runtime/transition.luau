--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local schedulerModule = require(script.Parent.Parent.core.scheduler)
local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type TransitionId = number

local pendingChanged: signalModule.Signal<number> = signalModule.new()
local pendingCount = 0
local nextTransitionId = 0
local currentIds: { [thread]: TransitionId } = {}
local completionCallbacks: { [TransitionId]: { () -> () } } = {}

do
	local weakCurrentIds: any = currentIds
	setmetatable(weakCurrentIds, {
		__mode = "k",
	})
end

local function currentThread(): thread
	local running = coroutine.running()
	assert(running, "Reactily transition requires a running coroutine.")
	return running
end

local function finishTransition(id: TransitionId)
	local callbacks = completionCallbacks[id]
	completionCallbacks[id] = nil

	if callbacks then
		for _, callback in callbacks do
			local success, failure = pcall(function(): boolean
				callback()
				return true
			end)
			if not success then
				warn(`Reactily transition completion callback failed: {failure}`)
			end
		end
		table.clear(callbacks)
	end

	pendingCount = math.max(pendingCount - 1, 0)
	pendingChanged.fire(pendingCount)
end

--- Returns the active transition id for the current coroutine.
--- @return transitionId? Active transition id.
function module.getCurrentId(): TransitionId?
	return currentIds[currentThread()]
end

--- Returns whether code is currently executing inside a transition Action.
--- @return boolean Whether a transition is active.
function module.isActive(): boolean
	return module.getCurrentId() ~= nil
end

--- Returns the number of pending transitions.
--- @return number Pending transition count.
function module.getPendingCount(): number
	return pendingCount
end

--- Subscribes to global pending transition count changes.
--- @param callback (count: number) -> () Subscriber.
--- @return () -> () Cleanup function.
function module.subscribe(callback: (count: number) -> ()): () -> ()
	local connection = pendingChanged.connect(callback)
	return function()
		connection.disconnect()
	end
end

--- Registers work to run when the current transition completes.
--- @param callback () -> () Completion callback.
--- @return boolean Whether it was registered to an active transition.
function module.onCurrentFinished(callback: () -> ()): boolean
	local id = module.getCurrentId()
	if not id then
		return false
	end

	local callbacks = completionCallbacks[id]
	if not callbacks then
		callbacks = {}
		completionCallbacks[id] = callbacks
	end
	callbacks[#callbacks + 1] = callback
	return true
end

--- Starts transition-priority Action work.
--- The callback may yield. Priority is coroutine-local and remains Transition
--- across yields in this Action without affecting unrelated Roblox threads.
--- @param callback () -> () Transition Action.
--- @param onFinished (() -> ())? Optional completion callback.
--- @return thread Spawned transition thread.
function module.start(callback: () -> (), onFinished: (() -> ())?): thread
	assert(type(callback) == "function", "Reactily transition callback must be a function.")

	nextTransitionId += 1
	local id = nextTransitionId

	pendingCount += 1
	pendingChanged.fire(pendingCount)

	return task.spawn(function()
		local running = currentThread()
		currentIds[running] = id

		local success, failure = pcall(function()
			schedulerModule.runWithPriority(schedulerModule.Priority.transition, callback)
		end)

		currentIds[running] = nil

		if onFinished then
			local finishedSuccess, finishedFailure = pcall(function(): boolean
				onFinished()
				return true
			end)
			if not finishedSuccess then
				warn(`Reactily transition onFinished callback failed: {finishedFailure}`)
			end
		end

		finishTransition(id)

		if not success then
			error(failure, 0)
		end
	end)
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.startTransition = module.start

return module
