--!strict

return function(modules: any, test: any, expectEqual: any)
	local resourceModule = modules.resource
	local bindingModule = modules.binding

	local function pendingResource()
		local loaderThread: thread? = nil
		local resource = resourceModule.new(function()
			loaderThread = coroutine.running()
			return coroutine.yield()
		end)
		local success, suspension = pcall(resource.read)
		expectEqual(success, false)
		expectEqual(resourceModule.isSuspension(suspension), true)

		return resource,
			suspension,
			function(value: any)
				assert(loaderThread, "The pending resource did not start its loader.")
				local resumed, failure = coroutine.resume(loaderThread, value)
				assert(resumed, tostring(failure))
			end
	end

	test("resources return synchronous results without suspending", function()
		local loads = 0
		local resource = resourceModule.new(function()
			loads += 1
			return false
		end)
		expectEqual(resource.read(), false)
		expectEqual(resource.read(), false)
		expectEqual(resource.getStatus(), "Resolved")
		expectEqual(loads, 1)
		resource.delete()

		local nilResource = resourceModule.new(function()
			return nil
		end)
		expectEqual(nilResource.read(), nil)
		expectEqual(nilResource.getStatus(), "Resolved")
		nilResource.delete()
	end)

	test("resources surface synchronous loader errors on the initial read", function()
		local failure = { message = "loader failed" }
		local resource = resourceModule.new(function()
			error(failure, 0)
		end)
		local success, result = pcall(resource.read)
		expectEqual(success, false)
		expectEqual(result, failure)
		expectEqual(resource.getError(), failure)
		expectEqual(resource.getStatus(), "Rejected")
		resource.delete()
	end)

	test("suspensions replay completion when subscribing after resolution", function()
		local resource, suspension, complete = pendingResource()
		complete("ready")
		local notifications = 0
		local cleanup = suspension.subscribe(function()
			notifications += 1
		end)
		expectEqual(notifications, 0)
		modules.tasks.flush()
		expectEqual(notifications, 1)
		expectEqual(resource.read(), "ready")
		resource.refresh()
		complete("refreshed")
		expectEqual(notifications, 2)
		cleanup()
		resource.refresh()
		complete("after cleanup")
		expectEqual(notifications, 2)
		resource.delete()
	end)

	test("suspension cleanup and resource deletion cancel deferred replay", function()
		local resource, suspension, complete = pendingResource()
		complete("ready")
		local notifications = 0
		local cleanup = suspension.subscribe(function()
			notifications += 1
		end)
		cleanup()
		cleanup()
		modules.tasks.flush()
		expectEqual(notifications, 0)

		suspension.subscribe(function()
			notifications += 1
		end)
		resource.delete()
		modules.tasks.flush()
		expectEqual(notifications, 0)
	end)

	test("suspension subscriptions observe refresh completion until cleanup", function()
		local resource, suspension, complete = pendingResource()
		local notifications = 0
		local cleanup = suspension.subscribe(function()
			notifications += 1
		end)
		complete("first")
		expectEqual(notifications, 1)
		resource.refresh()
		complete("second")
		expectEqual(notifications, 2)
		cleanup()
		resource.refresh()
		complete("after cleanup")
		expectEqual(notifications, 2)
		resource.delete()
	end)

	test("suspension replay is skipped after a newer completion notification", function()
		local resource, suspension, complete = pendingResource()
		complete("ready")
		local notifications = 0
		local cleanup = suspension.subscribe(function()
			notifications += 1
		end)
		resource.refresh()
		complete("newer")
		expectEqual(notifications, 1)
		modules.tasks.flush()
		expectEqual(notifications, 1)
		cleanup()
		resource.delete()
	end)

	test("refresh ignores stale loaders and deletion suppresses pending completion", function()
		local loaderThreads: { thread } = {}
		local resource = resourceModule.new(function()
			table.insert(loaderThreads, coroutine.running())
			return coroutine.yield()
		end)
		local notifications = 0
		resource.subscribe(function()
			notifications += 1
		end)
		resource.preload()
		resource.preload()
		expectEqual(#loaderThreads, 1)
		resource.refresh()
		expectEqual(#loaderThreads, 2)
		assert(coroutine.resume(loaderThreads[1], "stale"))
		expectEqual(resource.getStatus(), "Pending")
		expectEqual(resource.get(), nil)
		expectEqual(notifications, 0)
		assert(coroutine.resume(loaderThreads[2], "current"))
		expectEqual(resource.read(), "current")
		expectEqual(notifications, 1)

		resource.refresh()
		expectEqual(resource.delete(), true)
		expectEqual(resource.delete(), false)
		assert(coroutine.resume(loaderThreads[3], "deleted"))
		expectEqual(notifications, 1)
		expectEqual(resource.isDeleted(), true)
	end)

	test("synchronous lazy components render on their first invocation", function()
		local loads = 0
		local component = modules.lazy.new(function()
			loads += 1
			return function(props: any)
				return props.value
			end
		end)
		expectEqual(component({ value = "first" }), "first")
		expectEqual(component({ value = "second" }), "second")
		expectEqual(modules.lazy.preload(component), true)
		expectEqual(loads, 1)
	end)

	test("combineMany keeps its subscribed sources when the input array changes", function()
		local first = bindingModule.new(2)
		local second = bindingModule.new(3)
		local replacement = bindingModule.new(100)
		local sources = { first, second }
		local output = bindingModule.combineMany(sources, function(values: { number })
			return values[1] + values[2]
		end)
		sources[1] = replacement
		first.set(4)
		expectEqual(output.get(), 7)
		replacement.set(200)
		expectEqual(output.get(), 7)
		table.clear(sources)
		second.set(5)
		expectEqual(output.get(), 9)
		output.delete()
		first.delete()
		second.delete()
		replacement.delete()
	end)

	test("mapped bindings retain the newest result after a reentrant mapper", function()
		local source = bindingModule.new(1)
		local output = bindingModule.map(source, function(value: number)
			if value == 2 then
				source.set(3)
			end
			return value * 10
		end)
		source.set(2)
		expectEqual(source.get(), 3)
		expectEqual(output.get(), 30)
		output.delete()
		source.delete()
	end)

	test("mapped bindings discard a stale result after the mapper yields", function()
		local source = bindingModule.new(1)
		local output = bindingModule.map(source, function(value: number)
			if value == 2 then
				coroutine.yield()
			end
			return value * 10
		end)
		local updateThread = coroutine.create(function()
			source.set(2)
		end)
		assert(coroutine.resume(updateThread))
		source.set(3)
		expectEqual(output.get(), 30)
		assert(coroutine.resume(updateThread))
		expectEqual(output.get(), 30)
		output.delete()
		source.delete()
	end)

	test("derived bindings do not commit after deletion inside a mapper", function()
		local source = bindingModule.new(1)
		local output: any = nil
		output = bindingModule.map(source, function(value: number)
			if value == 2 then
				output.delete()
			end
			return value * 10
		end)
		local commits = 0
		local set = output.set
		output.set = function(value: number)
			commits += 1
			return set(value)
		end
		source.set(2)
		expectEqual(output.isDeleted(), true)
		expectEqual(commits, 0)
		source.delete()
	end)

	test("combined bindings retain the newest result after a reentrant mapper", function()
		for _, useMany in { false, true } do
			local first = bindingModule.new(1)
			local second = bindingModule.new(3)
			local function mapper(a: number, b: number)
				if a == 2 and b == 3 then
					second.set(10)
				end
				return a + b
			end
			local output
			if useMany then
				output = bindingModule.combineMany({ first, second }, function(values: { number })
					return mapper(values[1], values[2])
				end)
			else
				output = bindingModule.combine(first, second, mapper)
			end
			first.set(2)
			expectEqual(output.get(), 12)
			output.delete()
			first.delete()
			second.delete()
		end
	end)
end
