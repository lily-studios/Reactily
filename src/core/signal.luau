--!strict

-- provides typed Reactily-owned signals and derived signal operators

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type connection = {
	connected: boolean,
	disconnect: () -> boolean,
}

export type signal<T> = {
	connect: (callback: (value: T) -> ()) -> connection,
	delete: () -> boolean,
	fire: (value: T) -> (),
	getListenerCount: () -> number,
	isDeleted: () -> boolean,
	once: (callback: (value: T) -> ()) -> connection,
}

type listener<T> = {
	callback: (value: T) -> (),
	connection: connection?,
	isConnected: boolean,
	isOnce: boolean,
}

--————————————————————————————————————————————————————————————————————--

local function runListener<T>(callback: (value: T) -> (), value: T)
	local success, failure = pcall(callback, value)
	if success then return end

	warn(`Reactily signal listener failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

function module.distinct<T>(source: signal<T>): signal<T>
	local output = module.new<T>()
	local hasPrevious = false
	local previous: T? = nil
	local sourceConnection = source.connect(function(value: T)
		if hasPrevious and previous == value then return end

		hasPrevious = true
		previous = value
		output.fire(value)
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.filter<T>(source: signal<T>, predicate: (value: T) -> boolean): signal<T>
	local output = module.new<T>()
	local sourceConnection = source.connect(function(value: T)
		if not predicate(value) then return end

		output.fire(value)
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.map<A, B>(source: signal<A>, mapper: (value: A) -> B): signal<B>
	local output = module.new<B>()
	local sourceConnection = source.connect(function(value: A)
		output.fire(mapper(value))
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.merge<T>(sources: {signal<T>}): signal<T>
	local output = module.new<T>()
	local sourceConnections: {connection} = {}

	for _, source in sources do
		sourceConnections[#sourceConnections + 1] = source.connect(function(value: T)
			output.fire(value)
		end)
	end

	local outputDelete = output.delete

	output.delete = function(): boolean
		for _, connectionValue in sourceConnections do
			connectionValue.disconnect()
		end

		table.clear(sourceConnections)

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.new<T>(): signal<T>
	local isDeleted = false
	local listeners: {listener<T>} = {}

	local function removeListener(target: listener<T>)
		for index, listenerValue in listeners do
			if listenerValue ~= target then continue end

			table.remove(listeners, index)
			return
		end
	end

	local function createConnection(target: listener<T>): connection
		local connectionValue: connection

		connectionValue = {
			connected = true,

			disconnect = function(): boolean
				if not connectionValue.connected then return false end

				connectionValue.connected = false
				target.isConnected = false
				removeListener(target)

				return true
			end,
		}

		target.connection = connectionValue

		return connectionValue
	end

	local function connect(callback: (value: T) -> ()): connection
		assert(not isDeleted, "Reactily signal is deleted.")

		local target: listener<T> = {
			callback = callback,
			connection = nil,
			isConnected = true,
			isOnce = false,
		}

		listeners[#listeners + 1] = target

		return createConnection(target)
	end

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true

		for _, target in listeners do
			target.isConnected = false

			local connectionValue = target.connection
			if not connectionValue then continue end

			connectionValue.connected = false
		end

		table.clear(listeners)

		return true
	end

	local function fire(value: T)
		if isDeleted then return end
		if #listeners == 0 then return end

		local snapshot = table.clone(listeners)

		for _, target in snapshot do
			if not target.isConnected then continue end

			if target.isOnce and target.connection then
				target.connection.disconnect()
			end

			runListener(target.callback, value)
		end

		table.clear(snapshot)
	end

	local function getListenerCount(): number
		return #listeners
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function once(callback: (value: T) -> ()): connection
		assert(not isDeleted, "Reactily signal is deleted.")

		local target: listener<T> = {
			callback = callback,
			connection = nil,
			isConnected = true,
			isOnce = true,
		}

		listeners[#listeners + 1] = target

		return createConnection(target)
	end

	return {
		connect = connect,
		delete = delete,
		fire = fire,
		getListenerCount = getListenerCount,
		isDeleted = getIsDeleted,
		once = once,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.skip<T>(source: signal<T>, amount: number): signal<T>
	assert(amount >= 0, "Reactily skip amount must be non-negative.")

	local count = 0
	local output = module.new<T>()
	local sourceConnection = source.connect(function(value: T)
		count += 1
		if count <= amount then return end

		output.fire(value)
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.take<T>(source: signal<T>, maximum: number): signal<T>
	assert(maximum >= 0, "Reactily take maximum must be non-negative.")

	local count = 0
	local output = module.new<T>()
	local sourceConnection: connection?

	sourceConnection = source.connect(function(value: T)
		if count >= maximum then return end

		count += 1
		output.fire(value)

		if count < maximum then return end
		if not sourceConnection then return end

		sourceConnection.disconnect()
	end)

	local outputDelete = output.delete

	output.delete = function(): boolean
		if sourceConnection then
			sourceConnection.disconnect()
		end

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
