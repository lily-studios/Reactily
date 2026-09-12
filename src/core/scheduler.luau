--!strict

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
		
	if success then return end

	warn(`Reactily scheduled callback failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

function module.new(): scheduler
	local heartbeatConnection: RBXScriptConnection? = nil
	local isDeleted = false
	local isFlushing = false
	local keyedTasks: {[string]: scheduledTask} = {}
	local nextTaskId = 0
	local queuedTasks: {scheduledTask} = {}

	local flush: () -> ()

	local function stopHeartbeat()
		local connection = heartbeatConnection
		if not connection then return end

		connection:Disconnect()
		heartbeatConnection = nil
	end

	local function startHeartbeat()
		if isDeleted then return end
		if heartbeatConnection then return end
		if #queuedTasks == 0 then return end

		heartbeatConnection = runService.Heartbeat:Connect(function()
			stopHeartbeat()
			flush()
		end)
	end

	local function removeKey(taskValue: scheduledTask)
		local key = taskValue.key
		if not key then return end
		if keyedTasks[key] ~= taskValue then return end

		keyedTasks[key] = nil
	end

	local function removeQueuedTask(target: scheduledTask)
		for index, taskValue in queuedTasks do
			if taskValue ~= target then continue end

			table.remove(queuedTasks, index)
			return
		end
	end

	local function stopIfIdle()
		if #queuedTasks > 0 then return end

		stopHeartbeat()
	end

	local function cancel(taskIdValue: taskId): boolean
		for index, taskValue in queuedTasks do
			if taskValue.taskId ~= taskIdValue then continue end

			taskValue.isCancelled = true
			removeKey(taskValue)
			table.remove(queuedTasks, index)
			stopIfIdle()

			return true
		end

		return false
	end

	local function cancelKey(key: string): boolean
		local taskValue = keyedTasks[key]
		if not taskValue then return false end

		taskValue.isCancelled = true
		keyedTasks[key] = nil
		removeQueuedTask(taskValue)
		stopIfIdle()

		return true
	end

	local function clear()
		stopHeartbeat()

		for _, taskValue in queuedTasks do
			taskValue.isCancelled = true
		end

		table.clear(keyedTasks)
		table.clear(queuedTasks)
	end

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true
		clear()

		return true
	end

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

	flush = function()
		if isDeleted then return end
		if isFlushing then return end
		if #queuedTasks == 0 then return end

		isFlushing = true
		stopHeartbeat()

		local activeTasks = queuedTasks
		queuedTasks = {}

		for _, taskValue in activeTasks do
			removeKey(taskValue)
			if taskValue.isCancelled then continue end

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

	local function isPending(key: string): boolean
		local taskValue = keyedTasks[key]
		if not taskValue then return false end

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