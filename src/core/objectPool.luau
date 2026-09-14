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

--- Creates an Instance-backed object pool.
--- @param className string Roblox class name used to create new Instances.
--- @param maximumSize number Maximum number of released Instances retained by the pool.
--- @return objectPool<Instance> New Instance object pool.
function module.instance(className: string, maximumSize: number): objectPool<Instance>
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
): objectPool<T>
	assert(maximumSize >= 0, "Reactily object pool maximumSize must be non-negative.")

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

	local function acquire(): T
		assert(not isDeleted, "Reactily object pool is deleted.")

		local object = available[#available]

		if object ~= nil then
			table.remove(available, #available)

			return object
		end

		createdCount += 1

		return createObject()
	end

	local function clear()
		for _, object in available do
			deleteSafely(object)
		end

		table.clear(available)
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
