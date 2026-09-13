--!strict

-- manages Reactily-owned cleanup callbacks, connections, Instances, and child lifecycles

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type owner = {
	cleanups: {() -> ()},
	connections: {RBXScriptConnection},
	instances: {Instance},
	isDeleted: boolean,
}

--————————————————————————————————————————————————————————————————————--

local function removeConnection(ownerValue: owner, target: RBXScriptConnection)
	for index, connection in ownerValue.connections do
		if connection ~= target then continue end

		table.remove(ownerValue.connections, index)

		return
	end
end

--————————————————————————————————————————————————————————————————————--

local function removeInstance(ownerValue: owner, target: Instance)
	for index, instance in ownerValue.instances do
		if instance ~= target then continue end

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

	if success then return end

	warn(`Reactily cleanup failed: {failure}`)
end

--————————————————————————————————————————————————————————————————————--

--- Adds a cleanup callback that runs when the owner is deleted.
--- @param ownerValue owner The lifecycle owner.
--- @param callback () -> () Cleanup callback owned by the lifecycle.
--- @return () -> () The same cleanup callback.
function module.addCleanup(ownerValue: owner, callback: () -> ()): () -> ()
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")

	ownerValue.cleanups[#ownerValue.cleanups + 1] = callback

	return callback
end

--————————————————————————————————————————————————————————————————————--

--- Deletes the owner when the supplied Instance is destroyed.
--- @param ownerValue owner The lifecycle owner.
--- @param instance Instance Instance whose destruction controls the owner lifetime.
--- @return RBXScriptConnection The tracked Destroying connection.
function module.bindInstanceDeletion(
	ownerValue: owner,
	instance: Instance
): RBXScriptConnection
	return module.connect(ownerValue, instance.Destroying, function()
		module.delete(ownerValue)
	end)
end

--————————————————————————————————————————————————————————————————————--

--- Connects a Roblox signal and tracks the connection under the owner.
--- @param ownerValue owner The lifecycle owner.
--- @param signal RBXScriptSignal Roblox signal to connect.
--- @param callback (...any) -> () Callback invoked by the signal.
--- @return RBXScriptConnection The tracked connection.
function module.connect(
	ownerValue: owner,
	signal: RBXScriptSignal,
	callback: (...any) -> ()
): RBXScriptConnection
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")

	local connection = signal:Connect(callback)

	ownerValue.connections[#ownerValue.connections + 1] = connection

	return connection
end

--————————————————————————————————————————————————————————————————————--

--- Creates or replaces a named tracked connection.
--- @param ownerValue owner The lifecycle owner.
--- @param connections {[string]: RBXScriptConnection} Named connection storage.
--- @param name string Name used to identify the connection.
--- @param signal RBXScriptSignal Roblox signal to connect.
--- @param callback (...any) -> () Callback invoked by the signal.
--- @return RBXScriptConnection The newly tracked connection.
function module.connectNamed(
	ownerValue: owner,
	connections: {[string]: RBXScriptConnection},
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
--- @return owner The child lifecycle owner.
function module.createChild(parent: owner): owner
	assert(not parent.isDeleted, "Reactily parent owner is deleted.")

	local child = module.new()

	module.addCleanup(parent, function()
		module.delete(child)
	end)

	return child
end

--————————————————————————————————————————————————————————————————————--

--- Deletes an owner and all resources currently owned by it.
--- @param ownerValue owner The lifecycle owner.
--- @return boolean Whether deletion occurred.
function module.delete(ownerValue: owner): boolean
	if ownerValue.isDeleted then return false end

	ownerValue.isDeleted = true

	module.disconnectAll(ownerValue)
	module.runCleanups(ownerValue)
	module.deleteInstances(ownerValue)

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Removes and destroys one tracked Instance.
--- @param ownerValue owner The lifecycle owner.
--- @param instance Instance Instance to remove and destroy.
--- @return boolean Always returns true after destruction.
function module.deleteInstance(ownerValue: owner, instance: Instance): boolean
	removeInstance(ownerValue, instance)

	instance:Destroy()

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Destroys every Instance currently tracked by the owner.
--- @param ownerValue owner The lifecycle owner.
function module.deleteInstances(ownerValue: owner)
	for _, instance in ownerValue.instances do
		instance:Destroy()
	end

	table.clear(ownerValue.instances)
end

--————————————————————————————————————————————————————————————————————--

--- Removes and disconnects a tracked Roblox connection.
--- @param ownerValue owner The lifecycle owner.
--- @param connection RBXScriptConnection Connection to remove.
--- @return boolean Whether the connection was still connected.
function module.disconnect(
	ownerValue: owner,
	connection: RBXScriptConnection
): boolean
	removeConnection(ownerValue, connection)

	if not connection.Connected then return false end

	connection:Disconnect()

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Disconnects every Roblox connection tracked by the owner.
--- @param ownerValue owner The lifecycle owner.
function module.disconnectAll(ownerValue: owner)
	for _, connection in ownerValue.connections do
		if not connection.Connected then continue end

		connection:Disconnect()
	end

	table.clear(ownerValue.connections)
end

--————————————————————————————————————————————————————————————————————--

function module.getCleanupCount(ownerValue: owner): number
	return #ownerValue.cleanups
end

--————————————————————————————————————————————————————————————————————--

function module.getConnectionCount(ownerValue: owner): number
	return #ownerValue.connections
end

--————————————————————————————————————————————————————————————————————--

function module.getInstanceCount(ownerValue: owner): number
	return #ownerValue.instances
end

--————————————————————————————————————————————————————————————————————--

function module.isDeleted(ownerValue: owner): boolean
	return ownerValue.isDeleted
end

--————————————————————————————————————————————————————————————————————--

--- Creates an empty lifecycle owner.
--- @return owner A new active lifecycle owner.
function module.new(): owner
	return {
		cleanups = {},
		connections = {},
		instances = {},
		isDeleted = false,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Replaces a previously tracked Instance and tracks the replacement.
--- @param ownerValue owner The lifecycle owner.
--- @param current T? Previous value. Instances are removed and destroyed.
--- @param nextValue T Replacement value to track.
--- @return T The tracked replacement value.
function module.replaceInstance<T>(
	ownerValue: owner,
	current: T?,
	nextValue: T
): T
	if current and typeof(current) == "Instance" then
		module.deleteInstance(ownerValue, current :: any)
	end

	return module.trackInstance(ownerValue, nextValue)
end

--————————————————————————————————————————————————————————————————————--

--- Runs all cleanup callbacks in reverse registration order.
--- @param ownerValue owner The lifecycle owner.
function module.runCleanups(ownerValue: owner)
	for index = #ownerValue.cleanups, 1, -1 do
		runCleanup(ownerValue.cleanups[index])
	end

	table.clear(ownerValue.cleanups)
end

--————————————————————————————————————————————————————————————————————--

--- Tracks an Instance so it is destroyed with the owner.
--- @param ownerValue owner The lifecycle owner.
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