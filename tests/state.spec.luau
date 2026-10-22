--!strict

return function(modules: any, test: (string, () -> ()) -> (), expectEqual: (any, any) -> ())
	local hooks = modules.hooks
	local atom = modules.atom

	for _, phase in
		{
			{ name = "normal", use = hooks.useEffect, flush = hooks.flushEffects },
			{ name = "layout", use = hooks.useLayoutEffect, flush = hooks.flushLayoutEffects },
			{ name = "insertion", use = hooks.useInsertionEffect, flush = hooks.flushInsertionEffects },
		}
	do
		test(`hooks: {phase.name} effects stop on deletion and release returned cleanup`, function()
			local context = hooks.newContext(function() end)
			local events = {}
			hooks.beginRender(context)
			phase.use(function()
				table.insert(events, "first")
				hooks.deleteContext(context)
				return function()
					table.insert(events, "cleanup")
				end
			end, {})
			phase.use(function()
				table.insert(events, "second")
			end, {})
			hooks.endRender(context, true)
			phase.flush(context)
			expectEqual(table.concat(events, ","), "first,cleanup")
			expectEqual(hooks.deleteContext(context), false)
		end)
	end

	test("hooks: cleanup can delete its context without rerunning cleanup or effects", function()
		local context = hooks.newContext(function() end)
		local events = {}
		local function render(dependency: number)
			hooks.beginRender(context)
			hooks.useEffect(function()
				table.insert(events, "first")
				return function()
					table.insert(events, "cleanup:first")
					hooks.deleteContext(context)
				end
			end, { dependency })
			hooks.useEffect(function()
				table.insert(events, "second")
				return function()
					table.insert(events, "cleanup:second")
				end
			end, { dependency })
			hooks.endRender(context, true)
			hooks.flushEffects(context)
		end
		render(1)
		render(2)
		expectEqual(table.concat(events, ","), "first,second,cleanup:first,cleanup:second")
		expectEqual(context.isDeleted, true)
	end)

	test("hooks: pausing during an effect releases it and defers remaining effects", function()
		local context = hooks.newContext(function() end)
		local events = {}
		local firstRuns = 0
		hooks.beginRender(context)
		hooks.useEffect(function()
			firstRuns += 1
			local run = firstRuns
			table.insert(events, `first:{run}`)
			if run == 1 then
				hooks.pauseEffects(context)
			end
			return function()
				table.insert(events, `cleanup:{run}`)
			end
		end, {})
		hooks.useEffect(function()
			table.insert(events, "second")
		end, {})
		hooks.endRender(context, true)
		hooks.flushEffects(context)
		expectEqual(table.concat(events, ","), "first:1,cleanup:1")
		hooks.resumeEffects(context)
		hooks.deleteContext(context)
		expectEqual(table.concat(events, ","), "first:1,cleanup:1,first:2,second,cleanup:2")
	end)

	test("hooks: replay inside an effect invalidates its old queue and keeps new cleanup", function()
		local context = hooks.newContext(function() end)
		local events = {}
		local firstRuns = 0
		hooks.beginRender(context)
		hooks.useEffect(function()
			firstRuns += 1
			local run = firstRuns
			table.insert(events, `first:{run}`)
			if run == 1 then
				hooks.replayEffects(context)
			end
			return function()
				table.insert(events, `cleanup:{run}`)
			end
		end, {})
		hooks.useEffect(function()
			table.insert(events, "second")
		end, {})
		hooks.endRender(context, true)
		hooks.flushEffects(context)
		expectEqual(table.concat(events, ","), "first:1,first:2,second,cleanup:1")
		hooks.deleteContext(context)
		expectEqual(table.concat(events, ","), "first:1,first:2,second,cleanup:1,cleanup:2")
	end)

	test("hooks: pause cleanup can delete the context exactly once", function()
		local context = hooks.newContext(function() end)
		local cleanupCount = 0
		hooks.beginRender(context)
		hooks.useEffect(function()
			return function()
				cleanupCount += 1
				hooks.deleteContext(context)
			end
		end, {})
		hooks.endRender(context, true)
		hooks.flushEffects(context)
		hooks.pauseEffects(context)
		expectEqual(cleanupCount, 1)
		expectEqual(context.isDeleted, true)
	end)

	test("history atoms: subscribers observe committed history and nested edits retain order", function()
		local history = atom.createHistoryAtom(0, 5)
		local observedCount = 0
		local connection = history.subscribe(function(change: any)
			if change.current == 1 then
				observedCount = history.getPastCount()
				history.set(2)
			end
		end)
		expectEqual(history.set(1), true)
		expectEqual(observedCount, 1)
		expectEqual(history.get(), 2)
		expectEqual(history.getPastCount(), 2)
		connection.disconnect()
		expectEqual(history.undo(), true)
		expectEqual(history.get(), 1)
		expectEqual(history.undo(), true)
		expectEqual(history.get(), 0)
		expectEqual(history.undo(), false)
		history.delete()
	end)

	test("history atoms: edits made during undo invalidate redo and remain undoable", function()
		local history = atom.createHistoryAtom(0, 5)
		history.set(1)
		history.set(2)
		local connection = history.subscribe(function(change: any)
			if change.current == 1 then
				history.set(9)
			end
		end)
		expectEqual(history.undo(), true)
		connection.disconnect()
		expectEqual(history.get(), 9)
		expectEqual(history.canRedo(), false)
		expectEqual(history.getPastCount(), 2)
		expectEqual(history.undo(), true)
		expectEqual(history.get(), 1)
		expectEqual(history.undo(), true)
		expectEqual(history.get(), 0)
		history.delete()
	end)

	test("history atoms: notification cleanup cannot repopulate cleared or deleted history", function()
		local history = atom.createHistoryAtom(0, 5)
		local connection = history.subscribe(function()
			history.clearHistory()
		end)
		history.set(1)
		expectEqual(history.getPastCount(), 0)
		connection.disconnect()
		history.set(2)
		history.set(3)
		history.subscribe(function()
			history.delete()
		end)
		history.undo()
		expectEqual(history.isDeleted(), true)
		expectEqual(history.getPastCount(), 0)
		expectEqual(history.getFutureCount(), 0)
		expectEqual(history.canUndo(), false)
		expectEqual(history.canRedo(), false)
		expectEqual(history.delete(), false)
	end)

	test("history atoms: bounded history, no-op edits, redo, and nil values remain supported", function()
		local history = atom.createHistoryAtom(nil, 2)
		expectEqual(history.set(nil), false)
		history.set(1)
		history.set(2)
		expectEqual(history.getPastCount(), 2)
		expectEqual(history.undo(), true)
		expectEqual(history.get(), 1)
		expectEqual(history.undo(), true)
		expectEqual(history.get(), nil)
		expectEqual(history.redo(), true)
		expectEqual(history.get(), 1)
		expectEqual(history.redo(), true)
		expectEqual(history.get(), 2)
		history.set(3)
		expectEqual(history.getPastCount(), 2)
		history.undo()
		history.undo()
		expectEqual(history.get(), 1)
		expectEqual(history.undo(), false)
		history.delete()
	end)
end
