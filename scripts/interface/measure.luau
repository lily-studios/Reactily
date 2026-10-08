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

--- @reactilyType measureBounds
export type bounds = {
	AbsolutePosition: Vector2,
	AbsoluteSize: Vector2,
}

--- @reactilyType measure
export type measure = {
	delete: () -> boolean,
	get: () -> bounds,
	isDeleted: () -> boolean,
	subscribe: (callback: (value: bounds) -> ()) -> signalModule.connection,
}

--————————————————————————————————————————————————————————————————————--

local function read(object: GuiObject): bounds
	return {
		AbsolutePosition = object.AbsolutePosition,
		AbsoluteSize = object.AbsoluteSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Observes AbsolutePosition and AbsoluteSize for a GuiObject.
--- @param object GuiObject Object to measure.
--- @return measure Owned measurement observer.
function module.create(object: GuiObject): measure
	local changed = signalModule.new()
	local isDeleted = false
	local value = read(object)

	local function update()
		if isDeleted then
			return
		end

		local nextValue = read(object)
		if nextValue.AbsolutePosition == value.AbsolutePosition and nextValue.AbsoluteSize == value.AbsoluteSize then
			return
		end

		value = nextValue
		changed.fire(nextValue)
	end

	local positionConnection = object:GetPropertyChangedSignal("AbsolutePosition"):Connect(update)
	local sizeConnection = object:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		positionConnection:Disconnect()
		sizeConnection:Disconnect()
		changed.delete()
		return true
	end

	return {
		delete = delete,
		get = function(): bounds
			assert(not isDeleted, "Reactily measure is deleted.")
			return value
		end,
		isDeleted = function(): boolean
			return isDeleted
		end,
		subscribe = function(callback: (value: bounds) -> ()): signalModule.connection
			assert(not isDeleted, "Reactily measure is deleted.")
			return changed.connect(callback)
		end,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
