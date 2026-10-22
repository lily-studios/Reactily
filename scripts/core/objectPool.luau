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

export type ObjectPool<T> = {
	acquire: () -> T,
	clear: () -> (),
	delete: () -> boolean,
	getAvailableCount: () -> number,
	getCreatedCount: () -> number,
	isDeleted: () -> boolean,
	release: (object: T) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates an Instance-backed object pool.
--- @param className string Roblox class name used to create new Instances.
--- @param maximumSize number Maximum number of released Instances retained by the pool.
--- @return objectPool<Instance> New Instance object pool.
function module.instance(className: string, maximumSize: number): ObjectPool<Instance>
	return module.new(function(): Instance
		return Instance.new(className)
	end, function(instance: Instance)
		instance.Parent = nil
	end, function(instance: Instance)
		instance:Destroy()
	end, maximumSize)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reusable bounded object pool.
--- @param createObject () -> T Creates a new object when no retained object is available.
--- @param resetObject (object: T) -> () Resets an object before it is retained.
--- @param deleteObject (object: T) -> () Permanently disposes of an object.
--- @param maximumSize number Maximum number of released objects retained by the pool.
--- @return objectPool<T> New object pool.
function module.new<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): ObjectPool<T>
	assert(maximumSize >= 0, "Reactily object pool maximumSize must be non-negative.")

	local available: { T } = {}
	local availableSet: { [any]: boolean } = {}
	local busyObjects: { [any]: boolean } = {}
	local createdCount = 0
	local isDeleted = false

	local function deleteSafely(object: T)
		local success, failure = pcall(function(): boolean
			deleteObject(object)

			return true
		end)

		if success then
			return
		end
		warn(`Reactily object pool deletion failed: {failure}`)
	end

	local function acquire(): T
		assert(not isDeleted, "Reactily object pool is deleted.")

		local object = available[#available]

		if object ~= nil then
			table.remove(available, #available)
			availableSet[object] = nil

			return object
		end

		local createdObject = createObject()

		createdCount += 1
		return createdObject
	end

	local function clear()
		-- Detach retained objects before invoking user code. Disposal may call
		-- back into this pool, and must never acquire or retain a retiring object.
		local retiring = available
		available = {}
		availableSet = {}

		for _, object in retiring do
			busyObjects[object] = true
		end

		for _, object in retiring do
			deleteSafely(object)
		end

		for _, object in retiring do
			busyObjects[object] = nil
		end
		table.clear(retiring)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end
		isDeleted = true

		clear()

		return true
	end

	local function getAvailableCount(): number
		return #available
	end

	local function getCreatedCount(): number
		return createdCount
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function release(object: T): boolean
		if busyObjects[object] or availableSet[object] then
			return false
		end
		busyObjects[object] = true

		if isDeleted then
			deleteSafely(object)
			busyObjects[object] = nil

			return false
		end

		local success, failure = pcall(function(): boolean
			resetObject(object)
			return true
		end)

		if not success then
			busyObjects[object] = nil
			error(failure, 0)
		end

		-- Reset callbacks may yield or delete the pool before they return.
		if isDeleted or #available >= maximumSize then
			deleteSafely(object)
			busyObjects[object] = nil

			return false
		end

		available[#available + 1] = object
		availableSet[object] = true
		busyObjects[object] = nil

		return true
	end

	return {
		acquire = acquire,
		clear = clear,
		delete = delete,
		getAvailableCount = getAvailableCount,
		getCreatedCount = getCreatedCount,
		isDeleted = getIsDeleted,
		release = release,
	}
end

--————————————————————————————————————————————————————————————————————--

-- Canonical public API names (discoverable directly from Luau).
module.createInstancePool = module.instance
module.createObjectPool = module.new

return module
