--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type objectPool<T> = {
	acquire: () -> T,
	clear: () -> (),
	delete: () -> boolean,
	getAvailableCount: () -> number,
	getCreatedCount: () -> number,
	isDeleted: () -> boolean,
	release: (object: T) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a bounded object pool for Roblox Instances of the given class.
--- Released Instances are unparented before being retained.
--- @param className string Roblox class name used by Instance.new().
--- @param maximumSize number Maximum number of inactive Instances retained by the pool.
--- @return objectPool<Instance> A new Instance object pool.
function module.instance(className: string, maximumSize: number): objectPool<Instance>
	assert(className ~= "", "Reactily object pool class name must not be empty.")
	assert(maximumSize >= 0, "Reactily object pool maximum size must be non-negative.")

	local function createInstance(): Instance
		return Instance.new(className)
	end

	local function resetInstance(instance: Instance)
		instance.Parent = nil
	end

	local function deleteInstance(instance: Instance)
		instance:Destroy()
	end

	return module.new(createInstance, resetInstance, deleteInstance, maximumSize)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a bounded reusable object pool.
--- @param createObject () -> T Creates a new object when no retained object is available.
--- @param resetObject (object: T) -> () Resets an object before it is retained for reuse.
--- @param deleteObject (object: T) -> () Permanently deletes an object when it cannot be retained.
--- @param maximumSize number Maximum number of inactive objects retained by the pool.
--- @return objectPool<T> A new object pool.
function module.new<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): objectPool<T>
	assert(maximumSize >= 0, "Reactily object pool maximum size must be non-negative.")

	local available: { T } = {}

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

	--- Acquires a retained object or creates a new one when the pool is empty.
	--- @return T A reusable object owned by the caller until released.
	local function acquire(): T
		assert(not isDeleted, "Reactily object pool is deleted.")

		local object = available[#available]

		if object ~= nil then
			available[#available] = nil

			return object
		end

		createdCount += 1

		return createObject()
	end

	--- Permanently deletes every currently retained object.
	local function clear()
		for _, object in available do
			deleteSafely(object)
		end

		table.clear(available)
	end

	--- Deletes the pool and every currently retained object.
	--- Objects that are still acquired remain caller-owned until released.
	--- @return boolean Whether deletion occurred.
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

	--- Returns an object to the pool after resetting it.
	--- Objects released after deletion or beyond the retention limit are permanently deleted.
	--- @param object T Object being returned to the pool.
	--- @return boolean Whether the object was retained for reuse.
	local function release(object: T): boolean
		if isDeleted then
			deleteSafely(object)

			return false
		end

		resetObject(object)

		if #available >= maximumSize then
			deleteSafely(object)

			return false
		end

		available[#available + 1] = object

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

return module
