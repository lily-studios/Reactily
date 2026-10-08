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

--- @reactilyType History<T>
export type history<T> = {
	CanRedo: () -> boolean,
	CanUndo: () -> boolean,
	Clear: (value: T?) -> (),
	Delete: () -> boolean,
	Get: () -> T,
	IsDeleted: () -> boolean,
	Push: (value: T) -> boolean,
	Redo: () -> T?,
	Subscribe: (callback: (value: T) -> ()) -> signalModule.connection,
	Undo: () -> T?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates bounded undo/redo history.
--- @param initialValue T Initial state.
--- @param capacity number? Maximum number of retained states. Defaults to 100.
--- @return history<T> Owned history controller.
function module.Create<T>(initialValue: T, capacity: number?): history<T>
	local maximum = capacity or 100
	assert(maximum >= 1, "Reactily history capacity must be at least one.")

	local changed = signalModule.New()
	local index = 1
	local isDeleted = false
	local values: { T } = { initialValue }

	local function get(): T
		assert(not isDeleted, "Reactily history is deleted.")
		return values[index]
	end

	local function push(value: T): boolean
		assert(not isDeleted, "Reactily history is deleted.")
		if values[index] == value then
			return false
		end

		for removeIndex = #values, index + 1, -1 do
			table.remove(values, removeIndex)
		end

		values[#values + 1] = value
		if #values > maximum then
			table.remove(values, 1)
		else
			index += 1
		end

		index = #values
		changed.Fire(value)
		return true
	end

	local function undo(): T?
		assert(not isDeleted, "Reactily history is deleted.")
		if index <= 1 then
			return nil
		end

		index -= 1
		local value = values[index]
		changed.Fire(value)
		return value
	end

	local function redo(): T?
		assert(not isDeleted, "Reactily history is deleted.")
		if index >= #values then
			return nil
		end

		index += 1
		local value = values[index]
		changed.Fire(value)
		return value
	end

	local function clear(value: T?)
		assert(not isDeleted, "Reactily history is deleted.")
		local current = value
		if current == nil then
			current = values[index]
		end

		table.clear(values)
		values[1] = current :: T
		index = 1
		changed.Fire(current :: T)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		table.clear(values)
		changed.Delete()
		return true
	end

	return {
		CanRedo = function(): boolean
			return not isDeleted and index < #values
		end,
		CanUndo = function(): boolean
			return not isDeleted and index > 1
		end,
		Clear = clear,
		Delete = delete,
		Get = get,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		Push = push,
		Redo = redo,
		Subscribe = function(callback: (value: T) -> ()): signalModule.connection
			assert(not isDeleted, "Reactily history is deleted.")
			return changed.Connect(callback)
		end,
		Undo = undo,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
