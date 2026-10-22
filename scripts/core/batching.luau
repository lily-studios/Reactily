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
local pendingOrder: { () -> () } = {}

--————————————————————————————————————————————————————————————————————--

local function flushPending(): (boolean, unknown)
	if batchDepth > 0 then
		return true, nil
	end

	local success = true
	local firstFailure: unknown = nil

	while batchDepth == 0 and #pendingOrder > 0 do
		local callbacks = pendingOrder
		pendingOrder = {}
		table.clear(pendingCallbacks)

		for _, callback in callbacks do
			local callbackSuccess, failure = pcall(function(): boolean
				callback()
				return true
			end)

			if not callbackSuccess and success then
				success = false
				firstFailure = failure
			end
		end

		table.clear(callbacks)
	end

	return success, firstFailure
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

	if not pendingCallbacks[callback] then
		pendingCallbacks[callback] = true
		pendingOrder[#pendingOrder + 1] = callback
	end
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
	local flushSuccess, flushFailure = flushPending()

	-- Preserve the originating error while still delivering every pending
	-- notification. A failed observer must not leave other consumers stale.
	if not success then
		error(failure, 0)
	end
	if not flushSuccess then
		error(flushFailure, 0)
	end
end

--————————————————————————————————————————————————————————————————————--

-- Canonical public API names (discoverable directly from Luau).
module.batch = module.run

return module
