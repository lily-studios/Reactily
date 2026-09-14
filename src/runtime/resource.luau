--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type resourceStatus = "Idle" | "Pending" | "Rejected" | "Resolved"

export type suspension = {
	__reactilySuspension: boolean,
	subscribe: (callback: () -> ()) -> () -> (),
}

export type resource<T> = {
	delete: () -> boolean,
	get: () -> T?,
	getError: () -> any,
	getStatus: () -> resourceStatus,
	isDeleted: () -> boolean,
	preload: () -> (),
	read: () -> T,
	refresh: () -> (),
	subscribe: (callback: () -> ()) -> signalModule.connection,
}

--————————————————————————————————————————————————————————————————————--

local function createSuspension(ready: signalModule.signal<boolean>): suspension
	return {
		__reactilySuspension = true,

		subscribe = function(callback: () -> ()): () -> ()
			local connection = ready.connect(function(_value: boolean)
				callback()
			end)

			return function()
				connection.disconnect()
			end
		end,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether an error value represents a Reactily suspension request.
--- @param value any Error value to inspect.
--- @return boolean True when the value is a suspension token.
function module.isSuspension(value: any): boolean
	if type(value) ~= "table" then
		return false
	end
	if value.__reactilySuspension ~= true then
		return false
	end
	if type(value.subscribe) ~= "function" then
		return false
	end

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Creates a lazy resource whose loader runs only when first requested.
--- @param loader () -> T Loader that may yield and returns the resolved value.
--- @return resource<T> New resource.
function module.new<T>(loader: () -> T): resource<T>
	local changed: signalModule.signal<boolean> = signalModule.new()

	local errorValue: any = nil
	local generation = 0
	local isDeleted = false
	local status: resourceStatus = "Idle"
	local value: T? = nil

	local suspensionValue = createSuspension(changed)

	local startLoad: () -> ()

	startLoad = function()
		if isDeleted then
			return
		end
		if status == "Pending" then
			return
		end

		generation += 1

		local currentGeneration = generation

		status = "Pending"
		errorValue = nil

		task.spawn(function()
			local success, result = pcall(loader)

			if isDeleted then
				return
			end
			if generation ~= currentGeneration then
				return
			end

			if success then
				value = result
				status = "Resolved"
				changed.fire(true)

				return
			end

			errorValue = result
			status = "Rejected"
			changed.fire(true)
		end)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		generation += 1

		changed.delete()

		value = nil
		errorValue = nil

		return true
	end

	local function get(): T?
		assert(not isDeleted, "Reactily resource is deleted.")

		return value
	end

	local function getError(): any
		return errorValue
	end

	local function getStatus(): resourceStatus
		return status
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function preload()
		assert(not isDeleted, "Reactily resource is deleted.")
		if status ~= "Idle" then
			return
		end

		startLoad()
	end

	local function read(): T
		assert(not isDeleted, "Reactily resource is deleted.")

		if status == "Resolved" then
			return value :: T
		end

		if status == "Rejected" then
			error(errorValue, 0)
		end

		if status == "Idle" then
			startLoad()
		end

		error(suspensionValue, 0)
	end

	local function refresh()
		assert(not isDeleted, "Reactily resource is deleted.")

		value = nil
		startLoad()
	end

	local function subscribe(callback: () -> ()): signalModule.connection
		assert(not isDeleted, "Reactily resource is deleted.")

		return changed.connect(function(_value: boolean)
			callback()
		end)
	end

	return {
		delete = delete,
		get = get,
		getError = getError,
		getStatus = getStatus,
		isDeleted = getIsDeleted,
		preload = preload,
		read = read,
		refresh = refresh,
		subscribe = subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
