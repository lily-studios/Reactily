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

export type Bounds = {
	AbsolutePosition: Vector2,
	AbsoluteSize: Vector2,
}

export type Measure = {
	delete: () -> boolean,
	get: () -> Bounds,
	isDeleted: () -> boolean,
	subscribe: (callback: (value: Bounds) -> ()) -> signalModule.Connection,
}

--————————————————————————————————————————————————————————————————————--

local function read(object: GuiObject): Bounds
	return {
		AbsolutePosition = object.AbsolutePosition,
		AbsoluteSize = object.AbsoluteSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Observes AbsolutePosition and AbsoluteSize for a GuiObject.
--- @param object GuiObject Object to measure.
--- @return measure Owned measurement observer.
function module.create(object: GuiObject): Measure
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
		get = function(): Bounds
			assert(not isDeleted, "Reactily measure is deleted.")
			return value
		end,
		isDeleted = function(): boolean
			return isDeleted
		end,
		subscribe = function(callback: (value: Bounds) -> ()): signalModule.Connection
			assert(not isDeleted, "Reactily measure is deleted.")
			return changed.connect(callback)
		end,
	}
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
export type MeasureBounds = Bounds

return module
