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

--- @reactilyType DeviceState
export type deviceState = {
	HasGamepad: boolean,
	HasKeyboard: boolean,
	HasMouse: boolean,
	HasTouch: boolean,
	IsConsole: boolean,
	IsDesktop: boolean,
	IsMobile: boolean,
	Orientation: "Landscape" | "Portrait",
	ViewportSize: Vector2,
}

--- @reactilyType DeviceMonitor
export type deviceMonitor = {
	Delete: () -> boolean,
	Get: () -> deviceState,
	IsDeleted: () -> boolean,
	Subscribe: (callback: (value: deviceState) -> ()) -> signalModule.connection,
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

local function read(): deviceState
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
		HasGamepad = hasGamepad,
		HasKeyboard = hasKeyboard,
		HasMouse = hasMouse,
		HasTouch = hasTouch,
		IsConsole = isConsole,
		IsDesktop = not isConsole and not isMobile,
		IsMobile = isMobile,
		Orientation = orientation,
		ViewportSize = viewportSize,
	}
end

--————————————————————————————————————————————————————————————————————--

local function statesEqual(first: deviceState, second: deviceState): boolean
	return first.HasGamepad == second.HasGamepad
		and first.HasKeyboard == second.HasKeyboard
		and first.HasMouse == second.HasMouse
		and first.HasTouch == second.HasTouch
		and first.IsConsole == second.IsConsole
		and first.IsDesktop == second.IsDesktop
		and first.IsMobile == second.IsMobile
		and first.Orientation == second.Orientation
		and first.ViewportSize == second.ViewportSize
end

--————————————————————————————————————————————————————————————————————--

--- Creates an event-driven monitor for Roblox device and viewport capabilities.
--- @return deviceMonitor Owned device monitor.
function module.Create(): deviceMonitor
	local changed = signalModule.New()
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
		changed.Fire(nextValue)
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

		changed.Delete()
		return true
	end

	return {
		Delete = delete,
		Get = function(): deviceState
			assert(not isDeleted, "Reactily device monitor is deleted.")
			return value
		end,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		Subscribe = function(callback: (value: deviceState) -> ()): signalModule.connection
			assert(not isDeleted, "Reactily device monitor is deleted.")
			return changed.Connect(callback)
		end,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
