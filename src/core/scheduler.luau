--!strict

-- provides idle-safe one-shot scheduling through RunService.Heartbeat

local runService = game:GetService("RunService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type taskId = number

export type scheduler = {
	cancel: (taskId: taskId) -> boolean,
	cancelKey: (key: string) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	enqueue: (callback: () -> ()) -> taskId,
	enqueueKeyed: (key: string, callback: () -> ()) -> taskId,
	flush: () -> (),
	getPendingCount: () -> number,
	isDeleted: () -> boolean,
	isPending: (key: string) -> boolean,
}

type scheduledTask = {
	callback: () -> (),
	isCancelled: boolean,
	key: string?,
	taskId: taskId,
}

--————————————————————————————————————————————————————————————————————--

local function runScheduledCallback(callback: () -> ())
	local success, failure = pcall(function(): boolean
		callback()

		return true
	end)

	if success then
		return
	end

	warn(`Reactily scheduled callback failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an idle-safe scheduler that connects Heartbeat only while work is pending.
--- @return scheduler A new scheduler.
function module.new(): scheduler
	local heartbeatConnection: RBXScriptConnection? = nil

	local isDeleted = false
	local isFlushing = false
	local keyedTasks: { [string]: scheduledTask } = {}
	local nextTaskId = 0
	local queuedTasks: { scheduledTask } = {}

	local flush: () -> ()

	local function stopHeartbeat()
		local connection = heartbeatConnection

		if not connection then
			return
		end

		connection:Disconnect()

		heartbeatConnection = nil
	end

	local function startHeartbeat()
		if isDeleted then
			return
		end
		if heartbeatConnection then
			return
		end
		if #queuedTasks == 0 then
			return
		end

		heartbeatConnection = runService.Heartbeat:Connect(function()
			stopHeartbeat()

			flush()
		end)
	end

	local function removeKey(taskValue: scheduledTask)
		local key = taskValue.key

		if not key then
			return
		end
		if keyedTasks[key] ~= taskValue then
			return
		end

		keyedTasks[key] = nil
	end

	local function removeQueuedTask(target: scheduledTask)
		for index, taskValue in queuedTasks do
			if taskValue ~= target then
				continue
			end

			table.remove(queuedTasks, index)

			return
		end
	end

	local function stopIfIdle()
		if #queuedTasks > 0 then
			return
		end

		stopHeartbeat()
	end

	--- Cancels a pending task by its task ID.
	--- @param taskIdValue taskId Task ID returned by enqueue() or enqueueKeyed().
	--- @return boolean Whether a pending task was cancelled.
	local function cancel(taskIdValue: taskId): boolean
		for index, taskValue in queuedTasks do
			if taskValue.taskId ~= taskIdValue then
				continue
			end

			taskValue.isCancelled = true

			removeKey(taskValue)
			table.remove(queuedTasks, index)
			stopIfIdle()

			return true
		end

		return false
	end

	--- Cancels a pending keyed task.
	--- @param key string Key assigned through enqueueKeyed().
	--- @return boolean Whether a pending task existed for the key.
	local function cancelKey(key: string): boolean
		local taskValue = keyedTasks[key]

		if not taskValue then
			return false
		end

		taskValue.isCancelled = true
		keyedTasks[key] = nil

		removeQueuedTask(taskValue)
		stopIfIdle()

		return true
	end

	--- Cancels and removes all pending work without deleting the scheduler.
	local function clear()
		stopHeartbeat()

		for _, taskValue in queuedTasks do
			taskValue.isCancelled = true
		end

		table.clear(keyedTasks)
		table.clear(queuedTasks)
	end

	--- Deletes the scheduler and clears all pending work.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		clear()

		return true
	end

	--- Queues a callback for the next scheduler flush.
	--- @param callback () -> () Callback to execute.
	--- @return taskId ID that can be passed to cancel().
	local function enqueue(callback: () -> ()): taskId
		assert(not isDeleted, "Reactily scheduler is deleted.")

		nextTaskId += 1

		local taskValue: scheduledTask = {
			callback = callback,
			isCancelled = false,
			key = nil,
			taskId = nextTaskId,
		}

		queuedTasks[#queuedTasks + 1] = taskValue

		startHeartbeat()

		return taskValue.taskId
	end

	--- Queues keyed work or replaces the callback of an existing pending task with the same key.
	--- @param key string Stable identifier for the pending task.
	--- @param callback () -> () Callback to execute.
	--- @return taskId ID of the keyed task.
	local function enqueueKeyed(key: string, callback: () -> ()): taskId
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local existing = keyedTasks[key]

		if existing and not existing.isCancelled then
			existing.callback = callback

			return existing.taskId
		end

		nextTaskId += 1

		local taskValue: scheduledTask = {
			callback = callback,
			isCancelled = false,
			key = key,
			taskId = nextTaskId,
		}

		keyedTasks[key] = taskValue
		queuedTasks[#queuedTasks + 1] = taskValue

		startHeartbeat()

		return taskValue.taskId
	end

	--- Executes all currently pending work immediately.
	--- Work queued during the flush is deferred to the next flush.
	flush = function()
		if isDeleted then
			return
		end
		if isFlushing then
			return
		end
		if #queuedTasks == 0 then
			return
		end

		isFlushing = true

		stopHeartbeat()

		local activeTasks = queuedTasks

		queuedTasks = {}

		for _, taskValue in activeTasks do
			removeKey(taskValue)

			if taskValue.isCancelled then
				continue
			end

			runScheduledCallback(taskValue.callback)
		end

		table.clear(activeTasks)

		isFlushing = false

		startHeartbeat()
	end

	local function getPendingCount(): number
		return #queuedTasks
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--- Returns whether a keyed task is currently pending.
	--- @param key string Key assigned through enqueueKeyed().
	--- @return boolean Whether the keyed task is pending.
	local function isPending(key: string): boolean
		local taskValue = keyedTasks[key]

		if not taskValue then
			return false
		end

		return not taskValue.isCancelled
	end

	return {
		cancel = cancel,
		cancelKey = cancelKey,
		clear = clear,
		delete = delete,
		enqueue = enqueue,
		enqueueKeyed = enqueueKeyed,
		flush = flush,
		getPendingCount = getPendingCount,
		isDeleted = getIsDeleted,
		isPending = isPending,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
