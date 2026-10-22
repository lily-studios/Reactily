--!strict
-- Minimal fixture for pure runtime logic. This does not emulate Roblox rendering,
-- property events, wall-clock timers, or engine scheduling beyond explicit turns.
local connections: { any } = {}
local deferred: { any } = {}
local asyncFailures: { any } = {}
local heartbeat = {}
local tasks = {}
local taskMock = {}

local function resumeThread(threadValue: thread, ...: any)
	local success, failure = coroutine.resume(threadValue, ...)
	if not success then
		table.insert(asyncFailures, tostring(failure))
	end
end

function taskMock.spawn(callback: any, ...: any): thread
	local threadValue = if type(callback) == "thread" then callback else coroutine.create(callback)
	resumeThread(threadValue, ...)
	return threadValue
end

function taskMock.defer(callback: any, ...: any): thread
	local threadValue = if type(callback) == "thread" then callback else coroutine.create(callback)
	table.insert(deferred, { threadValue = threadValue, arguments = table.pack(...) })
	return threadValue
end

function taskMock.wait(): number
	local threadValue = coroutine.running()
	assert(threadValue, "task.wait requires a coroutine")
	taskMock.defer(threadValue, 0)
	return coroutine.yield()
end

function taskMock.cancel(threadValue: thread)
	if coroutine.status(threadValue) ~= "dead" then
		coroutine.close(threadValue)
	end
end

function tasks.step()
	local pending = deferred
	deferred = {}
	for _, entry in pending do
		if coroutine.status(entry.threadValue) ~= "dead" then
			resumeThread(entry.threadValue, table.unpack(entry.arguments, 1, entry.arguments.n))
		end
	end
end

function tasks.flush()
	local turns = 0
	while #deferred > 0 do
		turns += 1
		assert(turns <= 1000, "Deferred tasks did not settle after 1000 turns")
		tasks.step()
	end
end

function heartbeat:Connect(callback: (number) -> ())
	local connection = { Connected = true, callback = callback }
	function connection.Disconnect()
		connection.Connected = false
	end
	table.insert(connections, connection)
	return connection
end

function heartbeat.fire(delta: number?)
	for _, connection in table.clone(connections) do
		if connection.Connected then
			connection.callback(delta or 1 / 60)
		end
	end
end

function heartbeat.connectionCount(): number
	local count = 0
	for _, connection in connections do
		if connection.Connected then
			count += 1
		end
	end
	return count
end

local services: { [string]: any } = {
	RunService = { Heartbeat = heartbeat },
	CollectionService = {},
	GuiService = {},
	Players = {},
	Workspace = {},
	UserInputService = {},
	TweenService = {},
}

return {
	game = {
		GetService = function(_self: any, name: string): any
			assert(services[name], `Unsupported test service: {name}`)
			return services[name]
		end,
	},
	task = taskMock,
	warn = function(...: any)
		print("[runtime warning]", ...)
	end,
	heartbeat = heartbeat,
	tasks = tasks,
	assertClean = function()
		assert(#asyncFailures == 0, table.concat(asyncFailures, "\n"))
		assert(heartbeat.connectionCount() == 0, "Test leaked a Heartbeat connection")
		assert(#deferred == 0, "Test left deferred tasks pending; call modules.tasks.flush()")
	end,
	reset = function()
		for _, entry in deferred do
			taskMock.cancel(entry.threadValue)
		end
		table.clear(deferred)
		table.clear(connections)
		table.clear(asyncFailures)
	end,
}
