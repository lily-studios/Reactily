--!strict

return function(modules: any, test: any, expectEqual: any)
	local batching = modules.batching
	local schedulerModule = modules.scheduler
	local objectPool = modules.objectPool
	local priority = schedulerModule.Priority

	test("batching coalesces nested callbacks in first-queued order", function()
		local order = {}
		local function first()
			table.insert(order, "first")
		end
		expectEqual(batching.queue(first), false)
		batching.run(function()
			expectEqual(batching.isBatching(), true)
			batching.queue(first)
			batching.run(function()
				batching.queue(first)
				batching.queue(function()
					table.insert(order, "second")
				end)
			end)
			expectEqual(#order, 0)
		end)
		expectEqual(table.concat(order, ","), "first,second")
		expectEqual(batching.isBatching(), false)
	end)

	test("batching delivers remaining notifications after observer errors", function()
		local notified = false
		local failure = {}
		local success, caught = pcall(function()
			batching.run(function()
				batching.queue(function()
					error(failure)
				end)
				batching.queue(function()
					notified = true
				end)
			end)
		end)
		expectEqual(success, false)
		expectEqual(caught, failure)
		expectEqual(notified, true)
		expectEqual(batching.isBatching(), false)
		local recovered = false
		batching.run(function()
			batching.queue(function()
				recovered = true
			end)
		end)
		expectEqual(recovered, true)
	end)

	test("batching preserves the originating error while flushing notifications", function()
		local failure = {}
		local notified = false
		local success, caught = pcall(function()
			batching.run(function()
				batching.queue(function()
					error("observer failed")
				end)
				batching.queue(function()
					notified = true
				end)
				error(failure)
			end)
		end)
		expectEqual(success, false)
		expectEqual(caught, failure)
		expectEqual(notified, true)
	end)

	test("batching synchronously flushes batches opened by notification callbacks", function()
		local order = {}
		batching.run(function()
			batching.queue(function()
				table.insert(order, "outer")
				batching.run(function()
					batching.queue(function()
						table.insert(order, "nested")
					end)
				end)
				table.insert(order, "returned")
			end)
		end)
		expectEqual(table.concat(order, ","), "outer,nested,returned")
	end)

	test("scheduler keeps FIFO order and counts through cancellation compaction", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local taskIds = {}
		local seen = {}
		for index = 1, 512 do
			taskIds[index] = scheduler.enqueue(function()
				table.insert(seen, index)
			end)
		end
		for index = 1, 400 do
			expectEqual(scheduler.cancel(taskIds[index]), true)
		end
		expectEqual(scheduler.cancel(taskIds[1]), false)
		expectEqual(scheduler.getPendingCount(), 112)
		expectEqual(scheduler.getPendingCountByPriority(priority.normal), 112)
		expectEqual(modules.heartbeat.connectionCount(), 1)
		modules.heartbeat.fire()
		expectEqual(#seen, 112)
		for index, value in seen do
			expectEqual(value, index + 400)
		end
		expectEqual(scheduler.getPendingCount(), 0)
		expectEqual(modules.heartbeat.connectionCount(), 0)
		scheduler.delete()
	end)

	test("scheduler defers newly queued peers and honors cancellation during a flush", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local order = {}
		local cancelled = 0
		scheduler.enqueue(function()
			table.insert(order, "first")
			scheduler.cancel(cancelled)
			scheduler.enqueue(function()
				table.insert(order, "new")
			end)
		end)
		cancelled = scheduler.enqueue(function()
			table.insert(order, "cancelled")
		end)
		scheduler.enqueue(function()
			table.insert(order, "last")
		end)
		scheduler.flush()
		expectEqual(table.concat(order, ","), "first,last")
		expectEqual(scheduler.getPendingCount(), 1)
		scheduler.flush()
		expectEqual(table.concat(order, ","), "first,last,new")
		expectEqual(modules.heartbeat.connectionCount(), 0)
		scheduler.delete()
	end)

	test("scheduler clear during a callback defers replacement work safely", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local order = {}
		scheduler.enqueue(function()
			table.insert(order, "first")
			scheduler.clear()
			scheduler.enqueue(function()
				table.insert(order, "replacement")
			end)
		end)
		scheduler.enqueue(function()
			table.insert(order, "stale")
		end)
		scheduler.flush()
		expectEqual(table.concat(order, ","), "first")
		expectEqual(scheduler.getPendingCount(), 1)
		scheduler.flush()
		expectEqual(table.concat(order, ","), "first,replacement")
		scheduler.delete()
	end)

	test("scheduler does not leave an idle heartbeat after callbacks enqueue lower-priority work", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local called = false
		scheduler.enqueuePriority(priority.immediate, function()
			scheduler.enqueuePriority(priority.normal, function()
				called = true
			end)
		end)
		scheduler.flush()
		expectEqual(called, true)
		expectEqual(scheduler.getPendingCount(), 0)
		expectEqual(modules.heartbeat.connectionCount(), 0)
		scheduler.delete()
	end)

	test("scheduler keyed replacement retains urgency and cancellation identity", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local value = ""
		local original = scheduler.enqueueKeyedPriority("work", priority.idle, function()
			value = "old"
		end)
		local urgent = scheduler.enqueueKeyedPriority("work", priority.userBlocking, function()
			value = "urgent"
		end)
		expectEqual(original == urgent, false)
		local replaced = scheduler.enqueueKeyedPriority("work", priority.idle, function()
			value = "latest"
		end)
		expectEqual(replaced, urgent)
		expectEqual(scheduler.getPendingCountByPriority(priority.userBlocking), 1)
		expectEqual(scheduler.getPendingCountByPriority(priority.idle), 0)
		scheduler.flushPriority(priority.userBlocking)
		expectEqual(value, "latest")
		expectEqual(scheduler.isPending("work"), false)
		expectEqual(modules.heartbeat.connectionCount(), 0)
		scheduler.delete()
	end)

	test("scheduler time slices preserve remaining order, urgent insertion, and cancellation", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 1e-12 })
		local order = {}
		scheduler.enqueue(function()
			table.insert(order, "first")
			scheduler.enqueue(function()
				table.insert(order, "new")
			end)
			scheduler.enqueuePriority(priority.immediate, function()
				table.insert(order, "urgent")
			end)
		end)
		scheduler.enqueue(function()
			table.insert(order, "second")
		end)
		local cancelled = scheduler.enqueue(function()
			table.insert(order, "cancelled")
		end)
		scheduler.enqueuePriority(priority.idle, function()
			table.insert(order, "idle")
		end)
		scheduler.flush()
		expectEqual(table.concat(order, ","), "first")
		expectEqual(scheduler.getPendingCount(), 5)
		expectEqual(scheduler.getPendingCountByPriority(priority.normal), 3)
		expectEqual(modules.heartbeat.connectionCount(), 1)
		modules.heartbeat.fire()
		expectEqual(table.concat(order, ","), "first,urgent,second")
		expectEqual(scheduler.getPendingCount(), 3)
		expectEqual(scheduler.cancel(cancelled), true)
		modules.heartbeat.fire()
		expectEqual(table.concat(order, ","), "first,urgent,second,new")
		expectEqual(scheduler.getPendingCount(), 1)
		modules.heartbeat.fire()
		expectEqual(table.concat(order, ","), "first,urgent,second,new,idle")
		expectEqual(scheduler.getPendingCount(), 0)
		expectEqual(modules.heartbeat.connectionCount(), 0)
		scheduler.delete()
	end)

	test("scheduler deletion inside a callback abandons remaining work", function()
		local scheduler = schedulerModule.new({ timeSliceSeconds = 0 })
		local staleCalls = 0
		scheduler.enqueue(function()
			scheduler.delete()
		end)
		scheduler.enqueue(function()
			staleCalls += 1
		end)
		scheduler.enqueuePriority(priority.idle, function()
			staleCalls += 1
		end)
		scheduler.flush()
		expectEqual(scheduler.isDeleted(), true)
		expectEqual(staleCalls, 0)
		expectEqual(modules.heartbeat.connectionCount(), 0)
		expectEqual(scheduler.delete(), false)
	end)

	test("object pools count only successful creation attempts", function()
		local fail = true
		local pool = objectPool.new(function()
			if fail then
				error("factory failed")
			end
			return {}
		end, function() end, function() end, 1)
		expectEqual(pcall(pool.acquire), false)
		expectEqual(pool.getCreatedCount(), 0)
		fail = false
		local object = pool.acquire()
		expectEqual(pool.getCreatedCount(), 1)
		expectEqual(pool.release(object), true)
		expectEqual(pool.acquire(), object)
		expectEqual(pool.getCreatedCount(), 1)
		pool.delete()
	end)

	test("object pools reject a release reentered by its reset callback", function()
		local pool: any
		local resets = 0
		local nestedRelease = true
		pool = objectPool.new(function()
			return {}
		end, function(object: any)
			resets += 1
			assert(resets == 1, "Reset reentered for the same object")
			nestedRelease = pool.release(object)
		end, function() end, 1)
		local object = pool.acquire()
		expectEqual(pool.release(object), true)
		expectEqual(nestedRelease, false)
		expectEqual(resets, 1)
		expectEqual(pool.getAvailableCount(), 1)
		expectEqual(pool.release(object), false)
		pool.delete()
	end)

	test("object pools dispose objects when reset deletes the pool", function()
		local pool: any
		local disposed = 0
		pool = objectPool.new(function()
			return {}
		end, function()
			pool.delete()
		end, function(object: any)
			disposed += 1
			assert(disposed == 1, "Disposal reentered for the same object")
			expectEqual(pool.release(object), false)
		end, 1)
		expectEqual(pool.release(pool.acquire()), false)
		expectEqual(pool.getAvailableCount(), 0)
		expectEqual(pool.isDeleted(), true)
		expectEqual(disposed, 1)
	end)

	test("object pool clear detaches retiring objects before disposal callbacks", function()
		local pool: any
		local disposed = {}
		local replacement: any = nil
		pool = objectPool.new(function()
			return {}
		end, function() end, function(object: any)
			disposed[object] = (disposed[object] or 0) + 1
			assert(disposed[object] == 1, "Disposal reentered for the same object")
			pool.clear()
			expectEqual(pool.release(object), false)
			if replacement == nil then
				replacement = pool.acquire()
			end
		end, 2)
		local first = pool.acquire()
		local second = pool.acquire()
		pool.release(first)
		pool.release(second)
		pool.clear()
		expectEqual(disposed[first], 1)
		expectEqual(disposed[second], 1)
		expectEqual(replacement == first or replacement == second, false)
		expectEqual(pool.getAvailableCount(), 0)
		expectEqual(pool.getCreatedCount(), 3)
		pool.delete()
		pool.release(replacement)
		expectEqual(disposed[replacement], 1)
	end)

	test("object pools recover after reset failures and preserve their capacity", function()
		local fail = true
		local disposed = 0
		local pool = objectPool.new(function()
			return {}
		end, function()
			if fail then
				error("reset failed")
			end
		end, function()
			disposed += 1
		end, 1)
		local first = pool.acquire()
		local second = pool.acquire()
		expectEqual(pcall(pool.release, first), false)
		expectEqual(pool.getAvailableCount(), 0)
		fail = false
		expectEqual(pool.release(first), true)
		expectEqual(pool.release(second), false)
		expectEqual(disposed, 1)
		expectEqual(pool.getAvailableCount(), 1)
		pool.delete()
		expectEqual(disposed, 2)
	end)
end
