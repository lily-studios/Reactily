--!strict

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

function module.addCleanup(ownerValue: owner, callback: () -> ()): () -> ()
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")

	ownerValue.cleanups[#ownerValue.cleanups + 1] = callback

	return callback
end

--————————————————————————————————————————————————————————————————————--

function module.bindInstanceDeletion(ownerValue: owner, instance: Instance): RBXScriptConnection
	return module.connect(ownerValue, instance.Destroying, function()
		module.delete(ownerValue)
	end)
end

--————————————————————————————————————————————————————————————————————--

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

function module.createChild(parent: owner): owner
	assert(not parent.isDeleted, "Reactily parent owner is deleted.")

	local child = module.new()

	module.addCleanup(parent, function()
		module.delete(child)
	end)

	return child
end

--————————————————————————————————————————————————————————————————————--

function module.delete(ownerValue: owner): boolean
	if ownerValue.isDeleted then return false end

	ownerValue.isDeleted = true
	module.disconnectAll(ownerValue)
	module.runCleanups(ownerValue)
	module.deleteInstances(ownerValue)

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.deleteInstance(ownerValue: owner, instance: Instance): boolean
	removeInstance(ownerValue, instance)
	instance:Destroy()

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.deleteInstances(ownerValue: owner)
	for _, instance in ownerValue.instances do
		instance:Destroy()
	end

	table.clear(ownerValue.instances)
end

--————————————————————————————————————————————————————————————————————--

function module.disconnect(ownerValue: owner, connection: RBXScriptConnection): boolean
	removeConnection(ownerValue, connection)
	if not connection.Connected then return false end

	connection:Disconnect()

	return true
end

--————————————————————————————————————————————————————————————————————--

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

function module.new(): owner
	return {
		cleanups = {},
		connections = {},
		instances = {},
		isDeleted = false,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.replaceInstance<T>(ownerValue: owner, current: T?, nextValue: T): T
	if current and typeof(current) == "Instance" then
		module.deleteInstance(ownerValue, current :: any)
	end

	return module.trackInstance(ownerValue, nextValue)
end

--————————————————————————————————————————————————————————————————————--

function module.runCleanups(ownerValue: owner)
	for index = #ownerValue.cleanups, 1, -1 do
		runCleanup(ownerValue.cleanups[index])
	end

	table.clear(ownerValue.cleanups)
end

--————————————————————————————————————————————————————————————————————--

function module.trackInstance<T>(ownerValue: owner, instance: T): T
	assert(not ownerValue.isDeleted, "Reactily owner is deleted.")
	assert(typeof(instance) == "Instance", "Reactily lifecycle can only track Instances.")

	ownerValue.instances[#ownerValue.instances + 1] = instance :: any

	return instance
end

--————————————————————————————————————————————————————————————————————--

return module
