--!strict

-- owns reusable objects with bounded retention

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

function module.instance(className: string, maximumSize: number): objectPool<Instance>
	return module.new(
		function(): Instance
			return Instance.new(className)
		end,
		function(instance: Instance)
			instance.Parent = nil
		end,
		function(instance: Instance)
			instance:Destroy()
		end,
		maximumSize
	)
end

--————————————————————————————————————————————————————————————————————--

function module.new<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): objectPool<T>
	assert(maximumSize >= 0, "Reactily object pool maximumSize must be non-negative.")

	local available: {T} = {}
	local createdCount = 0
	local isDeleted = false

	local function deleteSafely(object: T)
		local success, failure = pcall(deleteObject, object)
		if success then return end

		warn(`Reactily object pool deletion failed: {failure}`)
	end

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

	local function clear()
		for _, object in available do
			deleteSafely(object)
		end

		table.clear(available)
	end

	local function delete(): boolean
		if isDeleted then return false end

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
