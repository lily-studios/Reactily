--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict


--————————————————————————————————————————————————————————————————————--

local userInputService = game:GetService("UserInputService")
local workspaceService = game:GetService("Workspace")

--————————————————————————————————————————————————————————————————————--

local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type DeviceState = {
	hasGamepad: boolean,
	hasKeyboard: boolean,
	hasMouse: boolean,
	hasTouch: boolean,
	isConsole: boolean,
	isDesktop: boolean,
	isMobile: boolean,
	orientation: "Landscape" | "Portrait",
	viewportSize: Vector2,
}

export type DeviceMonitor = {
	delete: () -> boolean,
	get: () -> DeviceState,
	isDeleted: () -> boolean,
	subscribe: (callback: (value: DeviceState) -> ()) -> signalModule.Connection,
}

--————————————————————————————————————————————————————————————————————--

local function getViewportSize(): Vector2
	local camera = workspaceService.CurrentCamera
	if not camera then
		return Vector2.zero
	end

	return camera.ViewportSize
end

--————————————————————————————————————————————————————————————————————--

local function read(): DeviceState
	local viewportSize = getViewportSize()
	local hasTouch = userInputService.TouchEnabled
	local hasKeyboard = userInputService.KeyboardEnabled
	local hasMouse = userInputService.MouseEnabled
	local hasGamepad = userInputService.GamepadEnabled
	local isConsole = hasGamepad and not hasKeyboard and not hasTouch
	local isMobile = hasTouch and not hasKeyboard
	local orientation: "Landscape" | "Portrait" = "Landscape"

	if viewportSize.Y > viewportSize.X then
		orientation = "Portrait"
	end

	return {
		hasGamepad = hasGamepad,
		hasKeyboard = hasKeyboard,
		hasMouse = hasMouse,
		hasTouch = hasTouch,
		isConsole = isConsole,
		isDesktop = not isConsole and not isMobile,
		isMobile = isMobile,
		orientation = orientation,
		viewportSize = viewportSize,
	}
end

--————————————————————————————————————————————————————————————————————--

local function statesEqual(first: DeviceState, second: DeviceState): boolean
	return first.hasGamepad == second.hasGamepad
		and first.hasKeyboard == second.hasKeyboard
		and first.hasMouse == second.hasMouse
		and first.hasTouch == second.hasTouch
		and first.isConsole == second.isConsole
		and first.isDesktop == second.isDesktop
		and first.isMobile == second.isMobile
		and first.orientation == second.orientation
		and first.viewportSize == second.viewportSize
end

--————————————————————————————————————————————————————————————————————--

--- Creates an event-driven monitor for Roblox device and viewport capabilities.
--- @return deviceMonitor Owned device monitor.
function module.create(): DeviceMonitor
	local changed = signalModule.new()
	local connections: { RBXScriptConnection } = {}
	local isDeleted = false
	local cameraConnection: RBXScriptConnection? = nil
	local value = read()

	local function update()
		if isDeleted then
			return
		end

		local nextValue = read()
		if statesEqual(value, nextValue) then
			return
		end

		value = nextValue
		changed.fire(nextValue)
	end

	local function connectCamera()
		if cameraConnection then
			cameraConnection:Disconnect()
			cameraConnection = nil
		end

		local camera = workspaceService.CurrentCamera
		if not camera then
			return
		end

		cameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(update)
	end

	connections[#connections + 1] = workspaceService:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		connectCamera()
		update()
	end)
	connections[#connections + 1] = userInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(update)
	connections[#connections + 1] = userInputService:GetPropertyChangedSignal("KeyboardEnabled"):Connect(update)
	connections[#connections + 1] = userInputService:GetPropertyChangedSignal("MouseEnabled"):Connect(update)
	connections[#connections + 1] = userInputService:GetPropertyChangedSignal("GamepadEnabled"):Connect(update)
	connectCamera()

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in connections do
			connection:Disconnect()
		end

		table.clear(connections)

		if cameraConnection then
			cameraConnection:Disconnect()
			cameraConnection = nil
		end

		changed.delete()
		return true
	end

	return {
		delete = delete,
		get = function(): DeviceState
			assert(not isDeleted, "Reactily device monitor is deleted.")
			return value
		end,
		isDeleted = function(): boolean
			return isDeleted
		end,
		subscribe = function(callback: (value: DeviceState) -> ()): signalModule.Connection
			assert(not isDeleted, "Reactily device monitor is deleted.")
			return changed.connect(callback)
		end,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
