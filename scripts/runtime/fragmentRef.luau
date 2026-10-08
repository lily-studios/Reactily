--[[
  Reactily · Lily Studios
  Copyright (c) Lily Studios and contributors.
  Licensed under the MIT License.
  See LICENSE in the repository root for full terms.
]]

--!strict

local guiService = game:GetService("GuiService")

local module = {}

--- Represents an imperative Fragment handle for managing host instances.
--- @field blur () -> () Clears the currently selected GUI object.
--- @field connectEvent (eventName: string, callback: (...any) -> ()) -> (() -> ()) Subscribes to an event across fragment instances.
--- @field delete () -> boolean Deletes the handle and disconnects its subscriptions.
--- @field focus () -> boolean Focuses the first eligible GUI object.
--- @field focusLast () -> boolean Focuses the last eligible GUI object.
--- @field getBounds () -> (Vector2?, Vector2?) Returns the combined position and size of GUI objects.
--- @field getInstances () -> {Instance} Returns the current host instances.
--- @field isDeleted () -> boolean Returns whether the handle has been deleted.
--- @field observeBounds (callback: () -> ()) -> (() -> ()) Subscribes to GUI bounds changes.
--- @field refresh () -> () Reconnects active subscriptions to current instances.
--- @field scrollIntoView (alignToTop: boolean?) -> boolean Scrolls a fragment GUI object into view.
export type fragmentInstance = {
	Blur: () -> (),
	ConnectEvent: (eventName: string, callback: (...any) -> ()) -> () -> (),
	Delete: () -> boolean,
	Focus: () -> boolean,
	FocusLast: () -> boolean,
	GetBounds: () -> (Vector2?, Vector2?),
	GetInstances: () -> { Instance },
	IsDeleted: () -> boolean,
	ObserveBounds: (callback: () -> ()) -> () -> (),
	Refresh: () -> (),
	ScrollIntoView: (alignToTop: boolean?) -> boolean,
}

--- Represents a mutable ref object or callback accepting a Fragment handle.
export type refTarget = { Current: fragmentInstance? } | ((value: fragmentInstance?) -> ())

--- Stores an event subscription and its active connections.
--- @field callback (...any) -> () Callback invoked when the event fires.
--- @field connections {RBXScriptConnection} Active event connections.
--- @field eventName string Name of the Roblox event being observed.
type eventBinding = {
	callback: (...any) -> (),
	Connections: { RBXScriptConnection },
	EventName: string,
}

--- Stores a bounds observer and its active connections.
--- @field callback () -> () Callback invoked when observed bounds change.
--- @field connections {RBXScriptConnection} Active property-change connections.
type boundsBinding = {
	callback: () -> (),
	Connections: { RBXScriptConnection },
}

--- Assigns a Fragment handle to a mutable ref or callback ref.
--- @param target refTarget? Optional target receiving the handle.
--- @param value fragmentInstance? Fragment handle to assign, or nil to clear it.
function module.Assign(target: refTarget?, value: fragmentInstance?)
	if not target then
		return
	end
	if type(target) == "function" then
		(target :: (fragmentInstance?) -> ())(value)
		return
	end
	target.Current = value
end

--- Collects visible and active GUI objects from the provided instance trees.
--- @param instances {Instance} Root instances to search recursively.
--- @return {GuiObject} Eligible GUI objects in traversal order.
local function collectFocusable(instances: { Instance }): { GuiObject }
	local output: { GuiObject } = {}

	--- Recursively visits an instance and its descendants.
	--- @param instance Instance Current instance to inspect.
	local function visit(instance: Instance)
		if instance:IsA("GuiObject") then
			local object = instance :: GuiObject
			if object.Visible and object.Active then
				output[#output + 1] = object
			end
		end
		for _, child in instance:GetChildren() do
			visit(child)
		end
	end

	for _, instance in instances do
		visit(instance)
	end
	return output
end

--- Disconnects all connections in a collection and clears it.
--- @param connections {RBXScriptConnection} Connections to disconnect.
local function disconnectAll(connections: { RBXScriptConnection })
	for _, connection in connections do
		connection:Disconnect()
	end
	table.clear(connections)
end

--- Creates an imperative Fragment handle for a dynamic collection of host instances.
--- @param getInstances () -> {Instance} Callback resolving the current host instances.
--- @return fragmentInstance Newly created Fragment handle.
function module.New(getInstances: () -> { Instance }): fragmentInstance
	local isDeleted = false
	local eventBindings: { eventBinding } = {}
	local boundsBindings: { boundsBinding } = {}

	--- Verifies that the Fragment handle has not been deleted.
	local function assertAlive()
		assert(not isDeleted, "Reactily FragmentInstance is deleted.")
	end

	--- Resolves the current instances after validating the handle.
	--- @return {Instance} Current host instances.
	local function get(): { Instance }
		assertAlive()
		return getInstances()
	end

	--- Connects an event binding to matching events on current host instances.
	--- @param binding eventBinding Event binding to attach.
	local function attachEvent(binding: eventBinding)
		disconnectAll(binding.Connections)

		for _, instance in get() do
			local target = instance :: any
			local success, signalValue = pcall(function(): any
				return target[binding.EventName]
			end)
			if success and typeof(signalValue) == "RBXScriptSignal" then
				binding.Connections[#binding.Connections + 1] = signalValue:Connect(binding.callback)
			end
		end
	end

	--- Connects a bounds observer to current GUI instances.
	--- @param binding boundsBinding Bounds observer to attach.
	local function attachBounds(binding: boundsBinding)
		disconnectAll(binding.Connections)

		for _, instance in get() do
			if not instance:IsA("GuiObject") then
				continue
			end
			local object = instance :: GuiObject
			binding.Connections[#binding.Connections + 1] =
				object:GetPropertyChangedSignal("AbsolutePosition"):Connect(binding.callback)
			binding.Connections[#binding.Connections + 1] =
				object:GetPropertyChangedSignal("AbsoluteSize"):Connect(binding.callback)
		end
	end

	--- Refreshes event and bounds subscriptions for current instances.
	local function refresh()
		assertAlive()
		for _, binding in eventBindings do
			attachEvent(binding)
		end
		for _, binding in boundsBindings do
			attachBounds(binding)
		end
	end

	--- Focuses the first or last eligible GUI object.
	--- @param last boolean Whether to select the last eligible object.
	--- @return boolean Whether a GUI object was successfully selected.
	local function focusFirst(last: boolean): boolean
		local focusable = collectFocusable(get())
		if #focusable == 0 then
			return false
		end
		local target = if last then focusable[#focusable] else focusable[1]
		guiService.SelectedObject = target
		return true
	end

	--- Subscribes to a named event on current Fragment host instances.
	--- @param eventName string Name of the Roblox event to observe.
	--- @param callback (...any) -> () Callback invoked when the event fires.
	--- @return () -> () Cleanup function that removes the event subscription.
	local function connectEvent(eventName: string, callback: (...any) -> ()): () -> ()
		assertAlive()
		assert(eventName ~= "", "Reactily FragmentInstance event name must not be empty.")
		assert(type(callback) == "function", "Reactily FragmentInstance callback must be a function.")

		local binding: eventBinding = {
			callback = callback,
			Connections = {},
			EventName = eventName,
		}
		eventBindings[#eventBindings + 1] = binding
		attachEvent(binding)

		local disconnected = false
		return function()
			if disconnected then
				return
			end
			disconnected = true
			disconnectAll(binding.Connections)
			local index = table.find(eventBindings, binding)
			if index then
				table.remove(eventBindings, index)
			end
		end
	end

	--- Subscribes to absolute position and size changes on current GUI instances.
	--- @param callback () -> () Callback invoked when observed bounds change.
	--- @return () -> () Cleanup function that removes the bounds observer.
	local function observeBounds(callback: () -> ()): () -> ()
		assertAlive()
		assert(type(callback) == "function", "Reactily FragmentInstance bounds observer must be a function.")

		local binding: boundsBinding = {
			callback = callback,
			Connections = {},
		}
		boundsBindings[#boundsBindings + 1] = binding
		attachBounds(binding)

		local disconnected = false
		return function()
			if disconnected then
				return
			end
			disconnected = true
			disconnectAll(binding.Connections)
			local index = table.find(boundsBindings, binding)
			if index then
				table.remove(boundsBindings, index)
			end
		end
	end

	--- Calculates the combined bounding rectangle of current GUI instances.
	--- @return Vector2? Minimum absolute position, or nil when no GUI objects exist.
	--- @return Vector2? Combined bounds size, or nil when no GUI objects exist.
	local function getBounds(): (Vector2?, Vector2?)
		local minimum: Vector2? = nil
		local maximum: Vector2? = nil

		for _, instance in get() do
			if not instance:IsA("GuiObject") then
				continue
			end
			local object = instance :: GuiObject
			local first = object.AbsolutePosition
			local last = first + object.AbsoluteSize
			minimum = if minimum then Vector2.new(math.min(minimum.X, first.X), math.min(minimum.Y, first.Y)) else first
			maximum = if maximum then Vector2.new(math.max(maximum.X, last.X), math.max(maximum.Y, last.Y)) else last
		end

		if not minimum or not maximum then
			return nil, nil
		end
		return minimum, maximum - minimum
	end

	--- Finds the closest ancestor ScrollingFrame for an instance.
	--- @param instance Instance Instance whose ancestors should be inspected.
	--- @return ScrollingFrame? Nearest scrolling ancestor, if one exists.
	local function findScrollingAncestor(instance: Instance): ScrollingFrame?
		local current = instance.Parent
		while current do
			if current:IsA("ScrollingFrame") then
				return current :: ScrollingFrame
			end
			current = current.Parent
		end
		return nil
	end

	--- Scrolls the first or last Fragment instance into its scrolling ancestor's viewport.
	--- @param alignToTop boolean? Whether to align the first instance to the top. False selects bottom alignment.
	--- @return boolean Whether a suitable GUI object and scrolling ancestor were found.
	local function scrollIntoView(alignToTop: boolean?): boolean
		local instances = get()
		local candidate = if alignToTop == false then instances[#instances] else instances[1]
		if not candidate or not candidate:IsA("GuiObject") then
			return false
		end

		local object = candidate :: GuiObject
		local scrolling = findScrollingAncestor(object)
		if not scrolling then
			return false
		end

		local relative = object.AbsolutePosition - scrolling.AbsolutePosition + scrolling.CanvasPosition
		local y = relative.Y
		if alignToTop == false then
			y = y - scrolling.AbsoluteWindowSize.Y + object.AbsoluteSize.Y
		end
		scrolling.CanvasPosition = Vector2.new(scrolling.CanvasPosition.X, math.max(y, 0))
		return true
	end

	--- Deletes the Fragment handle and releases all active subscriptions.
	--- @return boolean Whether the handle was deleted by this call.
	local function delete(): boolean
		if isDeleted then
			return false
		end
		isDeleted = true

		for _, binding in eventBindings do
			disconnectAll(binding.Connections)
		end
		for _, binding in boundsBindings do
			disconnectAll(binding.Connections)
		end
		table.clear(eventBindings)
		table.clear(boundsBindings)
		return true
	end

	return {
		Blur = function()
			assertAlive()
			guiService.SelectedObject = nil
		end,
		ConnectEvent = connectEvent,
		Delete = delete,
		Focus = function(): boolean
			return focusFirst(false)
		end,
		FocusLast = function(): boolean
			return focusFirst(true)
		end,
		GetBounds = getBounds,
		GetInstances = get,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		ObserveBounds = observeBounds,
		Refresh = refresh,
		ScrollIntoView = scrollIntoView,
	}
end

return module
