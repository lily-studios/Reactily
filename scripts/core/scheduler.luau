--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local RunService = game:GetService("RunService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

-- Luau does not support numeric singleton/literal union types such as
-- `1 | 2 | 3 | 4 | 5`, so priority is represented as a number and is
-- validated at every public boundary that accepts one.
export type priority = number

export type schedulerOptions = {
	TimeSliceSeconds: number?,
}

export type scheduler = {
	Cancel: (taskId: number) -> boolean,
	CancelKey: (key: string) -> boolean,
	Clear: () -> (),
	Delete: () -> boolean,
	Enqueue: (callback: () -> ()) -> number,
	EnqueueKeyed: (key: string, callback: () -> ()) -> number,
	EnqueueKeyedPriority: (key: string, priorityValue: priority, callback: () -> ()) -> number,
	EnqueuePriority: (priorityValue: priority, callback: () -> ()) -> number,
	Flush: () -> (),
	FlushPriority: (priorityValue: priority) -> (),
	GetPendingCount: () -> number,
	GetPendingCountByPriority: (priorityValue: priority) -> number,
	IsDeleted: () -> boolean,
	IsPending: (key: string) -> boolean,
}

type scheduledTask = {
	callback: () -> (),
	Key: string?,
	priority: priority,
}

type priorityTable = {
	Immediate: priority,
	UserBlocking: priority,
	Normal: priority,
	Transition: priority,
	Idle: priority,
}

-- Lower values are more urgent.
local priorityValues: priorityTable = table.freeze({
	Immediate = 1,
	UserBlocking = 2,
	Normal = 3,
	Transition = 4,
	Idle = 5,
})

module.Priority = priorityValues

-- Priority state is coroutine-local so a yielding transition never changes the
-- priority of unrelated Roblox threads.
local currentPriorities: { [thread]: priority } = {}

do
	local weakCurrentPriorities: any = currentPriorities

	setmetatable(weakCurrentPriorities, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

local function isValidPriority(priorityValue: priority): boolean
	return priorityValue == math.floor(priorityValue)
		and priorityValue >= priorityValues.Immediate
		and priorityValue <= priorityValues.Idle
end

local function assertPriority(priorityValue: priority)
	assert(isValidPriority(priorityValue), "Invalid Reactily priority.")
end

local function currentThread(): thread
	local running = coroutine.running()

	assert(running, "Reactily scheduler requires a running coroutine.")

	return running
end

--- Returns the priority currently associated with this coroutine.
--- @return priority Current scheduling priority.
function module.GetCurrentPriority(): priority
	local thread = currentThread()

	return currentPriorities[thread] or priorityValues.Normal
end

--- Returns whether the current coroutine is executing transition-priority work.
--- @return boolean True while inside transition work.
function module.IsTransitionPriority(): boolean
	return module.GetCurrentPriority() == priorityValues.Transition
end

--- Executes a callback with a coroutine-local scheduling priority.
--- The callback may yield; unrelated threads keep their own priorities.
--- Supports callbacks that return zero, one, or multiple values.
--- @param priorityValue priority Priority visible to state/render requests.
--- @param callback () -> T... Work to execute.
--- @return T... Callback results.
function module.RunWithPriority<T...>(priorityValue: priority, callback: () -> T...): T...
	assertPriority(priorityValue)
	assert(type(callback) == "function", "Reactily priority callback must be a function.")

	local thread = currentThread()
	local previous = currentPriorities[thread]

	currentPriorities[thread] = priorityValue

	-- `any` is intentionally localized here because the packed result contains
	-- pcall's leading success boolean followed by an arbitrary generic type pack.
	local result: any = table.pack(pcall(callback))

	if previous ~= nil then
		currentPriorities[thread] = previous
	else
		currentPriorities[thread] = nil
	end

	if not result[1] then
		error(result[2], 0)
	end

	return table.unpack(result, 2, result.n)
end

--————————————————————————————————————————————————————————————————————--

local function createQueues(): { [priority]: { number } }
	return {
		[priorityValues.Immediate] = {},
		[priorityValues.UserBlocking] = {},
		[priorityValues.Normal] = {},
		[priorityValues.Transition] = {},
		[priorityValues.Idle] = {},
	}
end

--- Creates an idle-safe, priority-aware scheduler.
--- Heartbeat is connected only while work exists. Lower-priority queues are
--- time-sliced so urgent work can be inserted before the next slice.
--- @param options schedulerOptions? Scheduler configuration.
--- @return scheduler New scheduler.
function module.New(options: schedulerOptions?): scheduler
	local heartbeatConnection: RBXScriptConnection? = nil
	local isDeleted = false
	local isFlushing = false
	local keyedTasks: { [string]: number } = {}
	local nextTaskId = 0
	local pendingCount = 0
	local pendingByPriority: { [priority]: number } = {
		[priorityValues.Immediate] = 0,
		[priorityValues.UserBlocking] = 0,
		[priorityValues.Normal] = 0,
		[priorityValues.Transition] = 0,
		[priorityValues.Idle] = 0,
	}
	local queues = createQueues()
	local tasks: { [number]: scheduledTask } = {}

	local timeSliceSeconds = 0.004

	if options ~= nil and options.TimeSliceSeconds ~= nil then
		local requestedTimeSlice = options.TimeSliceSeconds

		assert(
			requestedTimeSlice == requestedTimeSlice and requestedTimeSlice >= 0,
			"Reactily scheduler timeSliceSeconds must be a non-negative number."
		)

		timeSliceSeconds = requestedTimeSlice
	end

	local ensureHeartbeat: () -> ()
	local flush: () -> ()

	local function disconnectHeartbeat()
		local connection = heartbeatConnection

		if connection == nil then
			return
		end

		connection:Disconnect()
		heartbeatConnection = nil
	end

	local function removeTaskRecord(taskId: number, taskValue: scheduledTask)
		tasks[taskId] = nil
		pendingCount = math.max(pendingCount - 1, 0)
		pendingByPriority[taskValue.priority] = math.max((pendingByPriority[taskValue.priority] or 0) - 1, 0)

		local key = taskValue.Key

		if key ~= nil and keyedTasks[key] == taskId then
			keyedTasks[key] = nil
		end
	end

	local function clearPending()
		disconnectHeartbeat()
		table.clear(keyedTasks)
		table.clear(tasks)

		for _, queue in queues do
			table.clear(queue)
		end

		for priorityValue in pendingByPriority do
			pendingByPriority[priorityValue] = 0
		end

		pendingCount = 0
	end

	local function enqueueTask(callback: () -> (), key: string?, priorityValue: priority): number
		assertPriority(priorityValue)

		nextTaskId += 1

		local taskId = nextTaskId

		tasks[taskId] = {
			callback = callback,
			Key = key,
			priority = priorityValue,
		}

		local queue = queues[priorityValue]

		assert(queue ~= nil, "Reactily scheduler queue does not exist for this priority.")

		queue[#queue + 1] = taskId

		pendingCount += 1
		pendingByPriority[priorityValue] = (pendingByPriority[priorityValue] or 0) + 1

		if key ~= nil then
			keyedTasks[key] = taskId
		end

		ensureHeartbeat()

		return taskId
	end

	ensureHeartbeat = function()
		if isDeleted or pendingCount == 0 or heartbeatConnection ~= nil then
			return
		end

		heartbeatConnection = RunService.Heartbeat:Connect(function()
			disconnectHeartbeat()
			flush()
		end)
	end

	local function cancel(taskId: number): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskValue = tasks[taskId]

		if taskValue == nil then
			return false
		end

		removeTaskRecord(taskId, taskValue)

		if pendingCount == 0 then
			disconnectHeartbeat()
		end

		return true
	end

	local function cancelKey(key: string): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskId = keyedTasks[key]

		if taskId == nil then
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

	local function enqueuePriority(priorityValue: priority, callback: () -> ()): number
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assertPriority(priorityValue)
		assert(type(callback) == "function", "Reactily scheduler callback must be a function.")

		return enqueueTask(callback, nil, priorityValue)
	end

	local function enqueue(callback: () -> ()): number
		return enqueuePriority(module.GetCurrentPriority(), callback)
	end

	local function enqueueKeyedPriority(key: string, priorityValue: priority, callback: () -> ()): number
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assert(key ~= "", "Reactily scheduler key must not be empty.")
		assertPriority(priorityValue)
		assert(type(callback) == "function", "Reactily scheduler callback must be a function.")

		local existingTaskId = keyedTasks[key]

		if existingTaskId ~= nil then
			local existingTask = tasks[existingTaskId]

			if existingTask ~= nil then
				-- Keep the most urgent priority requested for the keyed work.
				local nextPriority = math.min(existingTask.priority, priorityValue)

				if nextPriority == existingTask.priority then
					existingTask.callback = callback

					return existingTaskId
				end

				cancel(existingTaskId)

				return enqueueTask(callback, key, nextPriority)
			end

			keyedTasks[key] = nil
		end

		return enqueueTask(callback, key, priorityValue)
	end

	local function enqueueKeyed(key: string, callback: () -> ()): number
		return enqueueKeyedPriority(key, module.GetCurrentPriority(), callback)
	end

	local function runTask(taskId: number)
		local taskValue = tasks[taskId]

		if taskValue == nil then
			return
		end

		removeTaskRecord(taskId, taskValue)

		local success, failure = pcall(function()
			module.RunWithPriority(taskValue.priority, taskValue.callback)
		end)

		if not success then
			warn(`Reactily scheduled task failed: {failure}`)
		end
	end

	local function flushOnePriority(priorityValue: priority, startedAt: number, respectBudget: boolean): boolean
		assertPriority(priorityValue)

		local queue = queues[priorityValue]

		assert(queue ~= nil, "Reactily scheduler queue does not exist for this priority.")

		if #queue == 0 then
			return false
		end

		local pendingQueue = table.clone(queue)

		table.clear(queue)

		for index, taskId in pendingQueue do
			if tasks[taskId] ~= nil then
				runTask(taskId)
			end

			if respectBudget and timeSliceSeconds > 0 and os.clock() - startedAt >= timeSliceSeconds then
				-- Requeue untouched task ids ahead of newer work at this same
				-- priority.
				local newerQueue = table.clone(queue)

				table.clear(queue)

				for remainingIndex = index + 1, #pendingQueue do
					local remainingTaskId = pendingQueue[remainingIndex]

					if tasks[remainingTaskId] ~= nil then
						queue[#queue + 1] = remainingTaskId
					end
				end

				for _, newerTaskId in newerQueue do
					queue[#queue + 1] = newerTaskId
				end

				return true
			end
		end

		return false
	end

	local function flushPriority(priorityValue: priority)
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assertPriority(priorityValue)

		if isFlushing then
			return
		end

		isFlushing = true
		disconnectHeartbeat()

		local success, failure = pcall(function()
			flushOnePriority(priorityValue, os.clock(), false)
		end)

		isFlushing = false

		if pendingCount > 0 then
			ensureHeartbeat()
		end

		if not success then
			error(failure, 0)
		end
	end

	flush = function()
		if isDeleted or isFlushing then
			return
		end

		disconnectHeartbeat()

		if pendingCount == 0 then
			return
		end

		isFlushing = true

		local success, failure = pcall(function()
			local startedAt = os.clock()

			-- Immediate and user-blocking work always drains in the current slice.
			flushOnePriority(priorityValues.Immediate, startedAt, false)
			flushOnePriority(priorityValues.UserBlocking, startedAt, false)

			local yielded = flushOnePriority(priorityValues.Normal, startedAt, true)

			if not yielded then
				yielded = flushOnePriority(priorityValues.Transition, startedAt, true)
			end

			if not yielded then
				flushOnePriority(priorityValues.Idle, startedAt, true)
			end
		end)

		isFlushing = false

		if pendingCount > 0 then
			ensureHeartbeat()
		end

		if not success then
			error(failure, 0)
		end
	end

	local function getPendingCount(): number
		assert(not isDeleted, "Reactily scheduler is deleted.")

		return pendingCount
	end

	local function getPendingCountByPriority(priorityValue: priority): number
		assert(not isDeleted, "Reactily scheduler is deleted.")
		assertPriority(priorityValue)

		return pendingByPriority[priorityValue] or 0
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function isPending(key: string): boolean
		assert(not isDeleted, "Reactily scheduler is deleted.")

		local taskId = keyedTasks[key]

		return taskId ~= nil and tasks[taskId] ~= nil
	end

	return {
		Cancel = cancel,
		CancelKey = cancelKey,
		Clear = clear,
		Delete = delete,
		Enqueue = enqueue,
		EnqueueKeyed = enqueueKeyed,
		EnqueueKeyedPriority = enqueueKeyedPriority,
		EnqueuePriority = enqueuePriority,
		Flush = flush,
		FlushPriority = flushPriority,
		GetPendingCount = getPendingCount,
		GetPendingCountByPriority = getPendingCountByPriority,
		IsDeleted = getIsDeleted,
		IsPending = isPending,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
