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

local batchDepth = 0
local pendingCallbacks: { [() -> ()]: boolean } = {}

--————————————————————————————————————————————————————————————————————--

local function flushPending()
	if batchDepth > 0 then
		return
	end
	if next(pendingCallbacks) == nil then
		return
	end

	local callbacks = table.clone(pendingCallbacks)
	table.clear(pendingCallbacks)

	for callback in callbacks do
		callback()
	end

	table.clear(callbacks)
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether a global Reactily batch is currently active.
--- @return boolean True while one or more nested batches are open.
function module.isBatching(): boolean
	return batchDepth > 0
end

--————————————————————————————————————————————————————————————————————--

--- Queues a callback for the end of the current global batch.
--- @param callback () -> () Callback that should run once after batching finishes.
--- @return boolean True when the callback was queued, false when no batch was active.
function module.queue(callback: () -> ()): boolean
	if batchDepth == 0 then
		return false
	end

	pendingCallbacks[callback] = true
	return true
end

--————————————————————————————————————————————————————————————————————--

--- Runs a callback inside a nested-safe global Reactily batch.
--- @param callback () -> () Work whose downstream notifications should be coalesced.
function module.run(callback: () -> ())
	batchDepth += 1

	local success, failure = pcall(function(): boolean
		callback()
		return true
	end)

	batchDepth -= 1
	flushPending()

	if success then
		return
	end
	error(failure, 0)
end

--————————————————————————————————————————————————————————————————————--

return module
