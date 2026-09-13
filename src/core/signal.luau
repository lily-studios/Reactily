--!strict

-- provides typed Reactily signals and derived signal operators

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
	local success, failure = pcall(function(): boolean
		callback(value)

		return true
	end)

	if success then return end

	warn(`Reactily signal listener failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that emits only when the value differs from the previous emission.
--- @param source signal<T> Source signal to observe.
--- @return signal<T> Derived signal that suppresses consecutive duplicate values.
function module.distinct<T>(source: signal<T>): signal<T>
	local output: signal<T> = module.new()

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

--- Creates a signal that emits only values accepted by the predicate.
--- @param source signal<T> Source signal to observe.
--- @param predicate (value: T) -> boolean Determines whether each emitted value should pass through.
--- @return signal<T> Filtered derived signal.
function module.filter<T>(
	source: signal<T>,
	predicate: (value: T) -> boolean
): signal<T>
	local output: signal<T> = module.new()

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

--- Creates a signal that transforms each emitted source value.
--- @param source signal<A> Source signal to observe.
--- @param mapper (value: A) -> B Converts each source value into the output value.
--- @return signal<B> Mapped derived signal.
function module.map<A, B>(
	source: signal<A>,
	mapper: (value: A) -> B
): signal<B>
	local output: signal<B> = module.new()

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

--- Creates one signal that forwards values from multiple source signals.
--- @param sources {signal<T>} Source signals to merge.
--- @return signal<T> Derived signal that emits values from every source.
function module.merge<T>(sources: {signal<T>}): signal<T>
	local output: signal<T> = module.new()
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

--- Creates a typed signal.
--- @return signal<T> A new active signal.
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

	--- Connects a listener to future signal emissions.
	--- @param callback (value: T) -> () Listener invoked whenever the signal fires.
	--- @return connection Connection used to stop future delivery.
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

	--- Deletes the signal and disconnects all listeners.
	--- @return boolean Whether deletion occurred.
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

	--- Emits a value to every currently connected listener.
	--- @param value T Value delivered to listeners.
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

	--- Connects a listener that automatically disconnects before its first callback runs.
	--- @param callback (value: T) -> () Listener invoked once.
	--- @return connection Connection that can cancel the listener before it fires.
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

--- Creates a signal that ignores the first number of source emissions.
--- @param source signal<T> Source signal to observe.
--- @param amount number Number of initial emissions to skip.
--- @return signal<T> Derived signal that emits after the skipped values.
function module.skip<T>(
	source: signal<T>,
	amount: number
): signal<T>
	assert(amount >= 0, "Reactily skip amount must be non-negative.")

	local count = 0
	local output: signal<T> = module.new()

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

--- Creates a signal that emits up to the requested number of source values.
--- The source connection disconnects automatically after the maximum is reached.
--- @param source signal<T> Source signal to observe.
--- @param maximum number Maximum number of values to emit.
--- @return signal<T> Derived signal limited to the requested number of emissions.
function module.take<T>(
	source: signal<T>,
	maximum: number
): signal<T>
	assert(maximum >= 0, "Reactily take maximum must be non-negative.")

	local count = 0
	local output: signal<T> = module.new()
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