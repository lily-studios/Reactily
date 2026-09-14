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

export type owner = {
	cleanups: { () -> () },
	connections: { RBXScriptConnection },
	instances: { Instance },
	isDeleted: boolean,
}

--————————————————————————————————————————————————————————————————————--

local function removeConnection(ownerValue: owner, target: RBXScriptConnection)
	for index, connection in ownerValue.connections do
		if connection ~= target then
			continue
		end
		table.remove(ownerValue.connections, index)
		return
	end
end

--————————————————————————————————————————————————————————————————————--

local function removeInstance(ownerValue: owner, target: Instance)
	for index, instance in ownerValue.instances do
		if instance ~= target then
			continue
		end
		table.remove(ownerValue.instances, index)
		return
	end
end

--————————————————————————————————————————————————————————————————————--

local function runCleanup(callback: () -> ())
	local success, failure = pcall(function(): boolean
		callback()

		return true
	end)

	if success then
		return
	end
	warn(`Reactily cleanup failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

--- Registers a cleanup callback with a lifecycle owner.
--- @param ownerValue owner Lifecycle owner.
--- @param callback () -> () Cleanup callback invoked when the owner is deleted.
--- @return () -> () The registered cleanup callback.
function module.addCleanup(ownerValue: owner, callback: () -> ()): () -> ()
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")
	ownerValue.cleanups[#ownerValue.cleanups + 1] = callback

	return callback
end

--————————————————————————————————————————————————————————————————————--

--- Deletes an owner automatically when an Instance is destroyed.
--- @param ownerValue owner Lifecycle owner.
--- @param instance Instance Instance whose destruction controls the owner.
--- @return RBXScriptConnection Managed Destroying connection.
function module.bindInstanceDeletion(ownerValue: owner, instance: Instance): RBXScriptConnection
	return module.connect(ownerValue, instance.Destroying, function()
		module.delete(ownerValue)
	end)
end

--————————————————————————————————————————————————————————————————————--

--- Connects an RBXScriptSignal and tracks the connection with an owner.
--- @param ownerValue owner Lifecycle owner.
--- @param signal RBXScriptSignal Signal to connect.
--- @param callback (...any) -> () Signal callback.
--- @return RBXScriptConnection Managed signal connection.
function module.connect(ownerValue: owner, signal: RBXScriptSignal, callback: (...any) -> ()): RBXScriptConnection
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")

	local connection = signal:Connect(callback)
	ownerValue.connections[#ownerValue.connections + 1] = connection

	return connection
end

--————————————————————————————————————————————————————————————————————--

--- Connects and stores a named signal connection, replacing any previous connection with the same name.
--- @param ownerValue owner Lifecycle owner.
--- @param connections {[string]: RBXScriptConnection} Named connection registry.
--- @param name string Connection name.
--- @param signal RBXScriptSignal Signal to connect.
--- @param callback (...any) -> () Signal callback.
--- @return RBXScriptConnection New managed connection.
function module.connectNamed(
	ownerValue: owner,
	connections: { [string]: RBXScriptConnection },
	name: string,
	signal: RBXScriptSignal,
	callback: (...any) -> ()
): RBXScriptConnection
	local previous = connections[name]

	if previous then
		module.disconnect(ownerValue, previous)
	end

	local connection = module.connect(ownerValue, signal, callback)
	connections[name] = connection

	return connection
end

--————————————————————————————————————————————————————————————————————--

--- Creates a child owner that is automatically deleted with its parent.
--- @param parent owner Parent lifecycle owner.
--- @return owner New child lifecycle owner.
function module.createChild(parent: owner): owner
	assert(not parent.isDeleted, "Reactily parent owner is deleted.")

	local child = module.new()

	module.addCleanup(parent, function()
		module.delete(child)
	end)

	return child
end

--————————————————————————————————————————————————————————————————————--

--- Deletes an owner and releases all resources it owns.
--- @param ownerValue owner Lifecycle owner.
--- @return boolean True when the owner was deleted, false when already deleted.
function module.delete(ownerValue: owner): boolean
	if ownerValue.isDeleted then
		return false
	end
	ownerValue.isDeleted = true

	module.disconnectAll(ownerValue)
	module.runCleanups(ownerValue)
	module.deleteInstances(ownerValue)

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Removes and destroys one tracked Instance.
--- @param ownerValue owner Lifecycle owner.
--- @param instance Instance Instance to destroy.
--- @return boolean True after the Instance is destroyed.
function module.deleteInstance(ownerValue: owner, instance: Instance): boolean
	removeInstance(ownerValue, instance)
	instance:Destroy()

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Destroys every Instance tracked by an owner.
--- @param ownerValue owner Lifecycle owner.
function module.deleteInstances(ownerValue: owner)
	for _, instance in ownerValue.instances do
		instance:Destroy()
	end

	table.clear(ownerValue.instances)
end

--————————————————————————————————————————————————————————————————————--

--- Removes and disconnects one managed signal connection.
--- @param ownerValue owner Lifecycle owner.
--- @param connection RBXScriptConnection Connection to disconnect.
--- @return boolean True when the connection was disconnected, false when already disconnected.
function module.disconnect(ownerValue: owner, connection: RBXScriptConnection): boolean
	removeConnection(ownerValue, connection)
	if not connection.Connected then
		return false
	end

	connection:Disconnect()

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Disconnects every signal connection tracked by an owner.
--- @param ownerValue owner Lifecycle owner.
function module.disconnectAll(ownerValue: owner)
	for _, connection in ownerValue.connections do
		if not connection.Connected then
			continue
		end
		connection:Disconnect()
	end

	table.clear(ownerValue.connections)
end

--————————————————————————————————————————————————————————————————————--

--- Returns the number of cleanup callbacks owned by an owner.
--- @param ownerValue owner Lifecycle owner.
--- @return number Number of registered cleanup callbacks.
function module.getCleanupCount(ownerValue: owner): number
	return #ownerValue.cleanups
end

--————————————————————————————————————————————————————————————————————--

--- Returns the number of signal connections owned by an owner.
--- @param ownerValue owner Lifecycle owner.
--- @return number Number of tracked connections.
function module.getConnectionCount(ownerValue: owner): number
	return #ownerValue.connections
end

--————————————————————————————————————————————————————————————————————--

--- Returns the number of Instances owned by an owner.
--- @param ownerValue owner Lifecycle owner.
--- @return number Number of tracked Instances.
function module.getInstanceCount(ownerValue: owner): number
	return #ownerValue.instances
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether a lifecycle owner has been deleted.
--- @param ownerValue owner Lifecycle owner.
--- @return boolean True when the owner has been deleted.
function module.isDeleted(ownerValue: owner): boolean
	return ownerValue.isDeleted
end

--————————————————————————————————————————————————————————————————————--

--- Creates an empty lifecycle owner.
--- @return owner New lifecycle owner.
function module.new(): owner
	return {
		cleanups = {},
		connections = {},
		instances = {},
		isDeleted = false,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Replaces a tracked Instance and destroys the previous Instance when present.
--- @param ownerValue owner Lifecycle owner.
--- @param current T? Previous tracked Instance.
--- @param nextValue T Replacement Instance.
--- @return T The newly tracked Instance.
function module.replaceInstance<T>(ownerValue: owner, current: T?, nextValue: T): T
	if current and typeof(current) == "Instance" then
		module.deleteInstance(ownerValue, current :: any)
	end

	return module.trackInstance(ownerValue, nextValue)
end

--————————————————————————————————————————————————————————————————————--

--- Runs and clears every cleanup callback owned by an owner.
--- @param ownerValue owner Lifecycle owner.
function module.runCleanups(ownerValue: owner)
	for index = #ownerValue.cleanups, 1, -1 do
		runCleanup(ownerValue.cleanups[index])
	end

	table.clear(ownerValue.cleanups)
end

--————————————————————————————————————————————————————————————————————--

--- Tracks an Instance so it is destroyed when the owner is deleted.
--- @param ownerValue owner Lifecycle owner.
--- @param instance T Instance to track.
--- @return T The same tracked Instance.
function module.trackInstance<T>(ownerValue: owner, instance: T): T
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")
	assert(typeof(instance) == "Instance", "Reactily lifecycle can only track Instances.")

	ownerValue.instances[#ownerValue.instances + 1] = instance :: any

	return instance
end

--————————————————————————————————————————————————————————————————————--

return module
