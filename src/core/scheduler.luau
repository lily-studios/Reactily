--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local runService = game:GetService("RunService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type scheduler = {
	cancel: (taskId: number) -> boolean,
	cancelKey: (key: string) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	enqueue: (callback: () -> ()) -> number,
	enqueueKeyed: (key: string, callback: () -> ()) -> number,
	flush: () -> (),
	getPendingCount: () -> number,
	isDeleted: () -> boolean,
	isPending: (key: string) -> boolean,
}

type scheduledTask = {
	callback: () -> (),
	key: string?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates an idle-safe scheduler for one-shot queued work.
--- @return scheduler New scheduler that connects Heartbeat only while work is pending.
function module.new(): scheduler
	local heartbeatConnection: RBXScriptConnection? = nil
	local isDeleted = false
	local isFlushing = false
	local keyedTasks: { [string]: number } = {}
	local nextTaskId = 0
	local pendingCount = 0
	local queue: { number } = {}
	local tasks: { [number]: scheduledTask } = {}

	local ensureHeartbeat: () -> ()
	local flush: () -> ()

	local function disconnectHeartbeat()
		local connection = heartbeatConnection
		if not connection then
			return
		end

		connection:Disconnect()
		heartbeatConnection = nil
	end

	local function clearPending()
		disconnectHeartbeat()
		table.clear(keyedTasks)
		table.clear(queue)
		table.clear(tasks)
		pendingCount = 0
	end

	local function enqueueTask(callback: () -> (), key: string?): number
		nextTaskId += 1

		local taskId = nextTaskId
		tasks[taskId] = {
			callback = callback,
			key = key,
		}
		queue[#queue + 1] = taskId
		pendingCount += 1

		if key then
			keyedTasks[key] = taskId
		end

		ensureHeartbeat()

		return taskId
	end

	ensureHeartbeat = function()
		if isDeleted then
			return
		end
		if pendingCount == 0 then
			return
		end
		if heartbeatConnection then
			return
		end

		heartbeatConnection = runService.Heartbeat:Connect(function()
			disconnectHeartbeat()
			flush()
		end)
	end

	local function cancel(taskId: number): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskValue = tasks[taskId]
		if not taskValue then
			return false
		end

		tasks[taskId] = nil
		pendingCount -= 1

		local key = taskValue.key
		if key and keyedTasks[key] == taskId then
			keyedTasks[key] = nil
		end

		if pendingCount == 0 then
			table.clear(queue)
			disconnectHeartbeat()
		end

		return true
	end

	local function cancelKey(key: string): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskId = keyedTasks[key]
		if not taskId then
			return false
		end

		return cancel(taskId)
	end

	local function clear()
		assert(not isDeleted, "Reactily scheduler is deleted.")
		clearPending()
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end
		isDeleted = true

		clearPending()

		return true
	end

	local function enqueue(callback: () -> ()): number
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assert(type(callback) == "function", "Reactily scheduler callback must be a function.")

		return enqueueTask(callback, nil)
	end

	local function enqueueKeyed(key: string, callback: () -> ()): number
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assert(key ~= "", "Reactily scheduler key must not be empty.")
		assert(type(callback) == "function", "Reactily scheduler callback must be a function.")

		local existingTaskId = keyedTasks[key]

		if existingTaskId then
			local existingTask = tasks[existingTaskId]

			if existingTask then
				existingTask.callback = callback

				return existingTaskId
			end

			keyedTasks[key] = nil
		end

		return enqueueTask(callback, key)
	end

	flush = function()
		if isDeleted then
			return
		end
		if isFlushing then
			return
		end

		disconnectHeartbeat()

		if pendingCount == 0 then
			table.clear(queue)
			return
		end

		isFlushing = true

		local pendingQueue = table.clone(queue)
		table.clear(queue)

		for _, taskId in pendingQueue do
			local taskValue = tasks[taskId]
			if not taskValue then
				continue
			end

			tasks[taskId] = nil
			pendingCount -= 1

			local key = taskValue.key
			if key and keyedTasks[key] == taskId then
				keyedTasks[key] = nil
			end

			local success, failure = pcall(function(): boolean
				taskValue.callback()

				return true
			end)

			if success then
				continue
			end
			warn(`Reactily scheduled task failed: {failure}`)
		end

		table.clear(pendingQueue)
		isFlushing = false

		if pendingCount > 0 then
			ensureHeartbeat()
		end
	end

	local function getPendingCount(): number
		assert(not isDeleted, "Reactily scheduler is deleted.")

		return pendingCount
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function isPending(key: string): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskId = keyedTasks[key]
		if not taskId then
			return false
		end

		return tasks[taskId] ~= nil
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
