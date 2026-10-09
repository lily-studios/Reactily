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

export type Connection = {
	connected: boolean,
	disconnect: () -> boolean,
}

export type Signal<T> = {
	connect: (callback: (value: T) -> ()) -> Connection,
	delete: () -> boolean,
	fire: (value: T) -> (),
	getListenerCount: () -> number,
	isDeleted: () -> boolean,
	once: (callback: (value: T) -> ()) -> Connection,
}

type Listener<T> = {
	callback: (value: T) -> (),
	connection: Connection?,
	isConnected: boolean,
	isOnce: boolean,
}

--————————————————————————————————————————————————————————————————————--

local function runListener<T>(callback: (value: T) -> (), value: T)
	local success, failure = pcall(function(): boolean
		callback(value)

		return true
	end)

	if success then
		return
	end
	warn(`Reactily signal listener failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a signal that emits only when the incoming value changes.
--- @param source signal<T> Source signal.
--- @return signal<T> Derived distinct signal.
function module.distinct<T>(source: Signal<T>): Signal<T>
	local output: Signal<T> = module.new()
	local hasPrevious = false
	local previous: T? = nil

	local sourceConnection = source.connect(function(value: T)
		if hasPrevious and previous == value then
			return
		end

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

--- Creates a signal that emits only values accepted by a predicate.
--- @param source signal<T> Source signal.
--- @param predicate (value: T) -> boolean Predicate deciding whether a value should emit.
--- @return signal<T> Filtered signal.
function module.filter<T>(source: Signal<T>, predicate: (value: T) -> boolean): Signal<T>
	local output: Signal<T> = module.new()

	local sourceConnection = source.connect(function(value: T)
		if not predicate(value) then
			return
		end
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

--- Creates a signal whose values are transformed by a mapper.
--- @param source signal<A> Source signal.
--- @param mapper (value: A) -> B Value transformation callback.
--- @return signal<B> Mapped signal.
function module.map<A, B>(source: Signal<A>, mapper: (value: A) -> B): Signal<B>
	local output: Signal<B> = module.new()

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

--- Combines multiple signals into one signal that forwards every emitted value.
--- @param sources {signal<T>} Source signals.
--- @return signal<T> Merged signal.
function module.merge<T>(sources: { Signal<T> }): Signal<T>
	local output: Signal<T> = module.new()
	local sourceConnections: { Connection } = {}

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

--- Creates a typed Reactily signal.
--- @return signal<T> New signal.
function module.new<T>(): Signal<T>
	local isDeleted = false
	local listeners: { Listener<T> } = {}

	local function removeListener(target: Listener<T>)
		for index, listenerValue in listeners do
			if listenerValue ~= target then
				continue
			end

			table.remove(listeners, index)
			return
		end
	end

	local function createConnection(target: Listener<T>): Connection
		local connectionValue: Connection

		connectionValue = {
			connected = true,
			disconnect = function(): boolean
				if not connectionValue.connected then
					return false
				end

				connectionValue.connected = false
				target.isConnected = false
				removeListener(target)

				return true
			end,
		}

		target.connection = connectionValue

		return connectionValue
	end

	local function connect(callback: (value: T) -> ()): Connection
		assert(not isDeleted, "Reactily signal is deleted.")

		local target: Listener<T> = {
			callback = callback,
			connection = nil,
			isConnected = true,
			isOnce = false,
		}

		listeners[#listeners + 1] = target

		return createConnection(target)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end
		isDeleted = true

		for _, target in listeners do
			target.isConnected = false

			local connectionValue = target.connection
			if not connectionValue then
				continue
			end

			connectionValue.connected = false
		end

		table.clear(listeners)

		return true
	end

	local function fire(value: T)
		if isDeleted then
			return
		end
		if #listeners == 0 then
			return
		end

		local snapshot = table.clone(listeners)

		for _, target in snapshot do
			if not target.isConnected then
				continue
			end

			if target.isOnce then
				local connectionValue = target.connection

				if connectionValue then
					connectionValue.disconnect()
				end
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

	local function once(callback: (value: T) -> ()): Connection
		assert(not isDeleted, "Reactily signal is deleted.")

		local target: Listener<T> = {
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

--- Creates a signal that ignores a number of initial emissions.
--- @param source signal<T> Source signal.
--- @param amount number Number of initial emissions to skip.
--- @return signal<T> Derived signal.
function module.skip<T>(source: Signal<T>, amount: number): Signal<T>
	assert(amount >= 0, "Reactily skip amount must be non-negative.")

	local count = 0
	local output: Signal<T> = module.new()

	local sourceConnection = source.connect(function(value: T)
		count += 1

		if count <= amount then
			return
		end
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

--- Creates a signal that forwards at most a fixed number of emissions.
--- @param source signal<T> Source signal.
--- @param maximum number Maximum number of values to emit.
--- @return signal<T> Limited signal.
function module.take<T>(source: Signal<T>, maximum: number): Signal<T>
	assert(maximum >= 0, "Reactily take maximum must be non-negative.")

	local output: Signal<T> = module.new()
	if maximum == 0 then
		return output
	end

	local count = 0
	local sourceConnection: Connection? = nil

	sourceConnection = source.connect(function(value: T)
		if count >= maximum then
			return
		end

		count += 1
		output.fire(value)

		if count < maximum then
			return
		end

		local activeConnection = sourceConnection
		if not activeConnection then
			return
		end

		activeConnection.disconnect()
	end)

	local outputDelete = output.delete

	output.delete = function(): boolean
		local activeConnection = sourceConnection

		if activeConnection then
			activeConnection.disconnect()
		end

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.createSignal = module.new
module.distinctSignal = module.distinct
module.filterSignal = module.filter
module.mapSignal = module.map
module.mergeSignals = module.merge
module.skipSignal = module.skip
module.takeSignal = module.take

return module
