--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local collectionService = game:GetService("CollectionService")

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)
local hostConfig = require(script.Parent.hostConfig)
local lifecycle = require(script.Parent.Parent.core.lifecycle)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

type initialProperty = {
	Value: any,
}

export type hostHandle = {
	Attributes: elementModule.attributeMap,
	ChangeConnections: { [string]: RBXScriptConnection },
	EventConnections: { [string]: RBXScriptConnection },
	InitialProperties: { [string]: initialProperty },
	Instance: Instance,
	Owner: lifecycle.owner,
	PropertyChangeConnections: { [string]: RBXScriptConnection },
	Props: elementModule.genericProps,
	RefTarget: elementModule.hostRefTarget<Instance>?,
	Tags: { [string]: boolean },
}

--————————————————————————————————————————————————————————————————————--

local function applyAttributes(handle: hostHandle, attributes: elementModule.attributeMap?)
	local nextAttributes: elementModule.attributeMap = {}

	if attributes then
		nextAttributes = attributes
	end

	for name in handle.Attributes do
		if nextAttributes[name] ~= nil then
			continue
		end
		if handle.Instance:GetAttribute(name) == nil then
			continue
		end

		handle.Instance:SetAttribute(name, nil)
	end

	for name, value in nextAttributes do
		if handle.Instance:GetAttribute(name) == value then
			continue
		end

		handle.Instance:SetAttribute(name, value)
	end

	handle.Attributes = table.clone(nextAttributes)
end

--————————————————————————————————————————————————————————————————————--

local function applyChange(handle: hostHandle, propName: string, callback: any)
	local propertyName = hostConfig.GetChangePropertyName(propName)
	assert(propertyName, `Reactily change prop "{propName}" is not registered.`)

	local previous = handle.ChangeConnections[propName]

	if previous then
		lifecycle.Disconnect(handle.Owner, previous)
		handle.ChangeConnections[propName] = nil
	end

	if callback == nil then
		return
	end

	assert(type(callback) == "function", `Reactily.Change.{propertyName} requires a callback.`)

	local success, signalOrFailure = pcall(function(): RBXScriptSignal
		return handle.Instance:GetPropertyChangedSignal(propertyName)
	end)

	assert(success, `Reactily.Change.{propertyName} is invalid for {handle.Instance.ClassName}: {signalOrFailure}`)

	local propertySignal = signalOrFailure :: RBXScriptSignal
	handle.ChangeConnections[propName] = lifecycle.Connect(handle.Owner, propertySignal, function()
		local target = handle.Instance :: any
		callback(target[propertyName])
	end)
end

--————————————————————————————————————————————————————————————————————--

local function applyEvent(handle: hostHandle, propName: string, callback: any)
	local eventName = hostConfig.GetEventName(propName)
	assert(eventName, `Reactily event prop "{propName}" is not registered.`)

	local previous = handle.EventConnections[propName]

	if previous then
		lifecycle.Disconnect(handle.Owner, previous)
		handle.EventConnections[propName] = nil
	end

	if callback == nil then
		return
	end

	local success, signalOrFailure = pcall(function(): any
		return (handle.Instance :: any)[eventName]
	end)

	assert(success, `Reactily event "{eventName}" is invalid for {handle.Instance.ClassName}: {signalOrFailure}`)
	assert(
		typeof(signalOrFailure) == "RBXScriptSignal",
		`Reactily event "{eventName}" is not a signal on {handle.Instance.ClassName}.`
	)

	handle.EventConnections[propName] = lifecycle.Connect(handle.Owner, signalOrFailure, callback)
end

--————————————————————————————————————————————————————————————————————--

local function applyProperty(handle: hostHandle, propName: string, value: any)
	local propertyName = hostConfig.GetPropertyName(propName)
	assert(propertyName, `Reactily prop "{propName}" is not supported by the host renderer.`)

	local target = handle.Instance :: any
	local readSuccess, currentOrFailure = pcall(function(): any
		return target[propertyName]
	end)

	assert(readSuccess, `Reactily prop "{propName}" is invalid for {handle.Instance.ClassName}: {currentOrFailure}`)
	if currentOrFailure == value then
		return
	end

	if not handle.InitialProperties[propName] then
		handle.InitialProperties[propName] = {
			Value = currentOrFailure,
		}
	end

	local writeSuccess, writeFailure = pcall(function()
		target[propertyName] = value
	end)

	assert(writeSuccess, `Reactily could not set "{propName}" on {handle.Instance.ClassName}: {writeFailure}`)
end

--————————————————————————————————————————————————————————————————————--

local function applyPropertyChanges(handle: hostHandle, callbacks: { [string]: (value: any) -> () }?)
	for _, connection in handle.PropertyChangeConnections do
		lifecycle.Disconnect(handle.Owner, connection)
	end

	table.clear(handle.PropertyChangeConnections)
	if not callbacks then
		return
	end

	for propertyName, callback in callbacks do
		assert(type(propertyName) == "string", "Reactily property-change names must be strings.")
		assert(type(callback) == "function", "Reactily property-change callbacks must be functions.")

		local success, signalOrFailure = pcall(function(): RBXScriptSignal
			return handle.Instance:GetPropertyChangedSignal(propertyName)
		end)

		assert(
			success,
			`Reactily property "{propertyName}" is invalid for {handle.Instance.ClassName}: {signalOrFailure}`
		)

		local propertySignal = signalOrFailure :: RBXScriptSignal
		handle.PropertyChangeConnections[propertyName] = lifecycle.Connect(handle.Owner, propertySignal, function()
			local target = handle.Instance :: any
			callback(target[propertyName])
		end)
	end
end

--————————————————————————————————————————————————————————————————————--

local function assignRef(target: elementModule.hostRefTarget<Instance>, value: Instance?)
	if type(target) == "function" then
		target(value)
		return
	end

	target.Current = value
end

--————————————————————————————————————————————————————————————————————--

local function applyRef(handle: hostHandle, target: elementModule.hostRefTarget<Instance>?)
	if handle.RefTarget == target then
		return
	end

	if handle.RefTarget then
		assignRef(handle.RefTarget, nil)
	end

	handle.RefTarget = target

	if target then
		assignRef(target, handle.Instance)
	end
end

--————————————————————————————————————————————————————————————————————--

local function applyTags(handle: hostHandle, tags: { string }?)
	local nextTags: { [string]: boolean } = {}

	if tags then
		for _, tag in tags do
			nextTags[tag] = true
		end
	end

	for tag in handle.Tags do
		if nextTags[tag] then
			continue
		end
		if not collectionService:HasTag(handle.Instance, tag) then
			continue
		end

		collectionService:RemoveTag(handle.Instance, tag)
	end

	for tag in nextTags do
		if collectionService:HasTag(handle.Instance, tag) then
			continue
		end

		collectionService:AddTag(handle.Instance, tag)
	end

	handle.Tags = nextTags
end

--————————————————————————————————————————————————————————————————————--

-- Host metadata is not a Roblox property and must never enter applyProperty.
-- Keep the keys in PascalCase to match virtual/element.luau.
local internalProps: { [string]: boolean } = table.freeze({
	Attributes = true,
	Children = true,
	Key = true,
	OnPropertyChanged = true,
	Ref = true,
	Tags = true,
})

local function isInternalProp(propName: string): boolean
	return internalProps[propName] == true
end

--————————————————————————————————————————————————————————————————————--

local function resetProperty(handle: hostHandle, propName: string)
	local initial = handle.InitialProperties[propName]
	if not initial then
		return
	end

	local propertyName = hostConfig.GetPropertyName(propName)
	if not propertyName then
		return
	end

	local target = handle.Instance :: any
	local readSuccess, currentValue = pcall(function(): any
		return target[propertyName]
	end)

	if not readSuccess then
		handle.InitialProperties[propName] = nil
		return
	end

	if currentValue ~= initial.Value then
		local writeSuccess, writeFailure = pcall(function()
			target[propertyName] = initial.Value
		end)

		if not writeSuccess then
			warn(`Reactily could not reset "{propName}" on {handle.Instance.ClassName}: {writeFailure}`)
		end
	end

	handle.InitialProperties[propName] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Creates and owns one Roblox host Instance for a virtual host element.
--- @param parent Instance Parent receiving the new host Instance.
--- @param elementValue element Reactily host element.
--- @return hostHandle Owned host handle.
function module.CreateHost(parent: Instance, elementValue: elementModule.element): hostHandle
	assert(elementValue.Kind == "host", "Reactily renderer can only create host elements.")

	local ownerValue = lifecycle.New()
	local instance = lifecycle.TrackInstance(ownerValue, Instance.new(elementValue.ClassName))
	local handle: hostHandle = {
		Attributes = {},
		ChangeConnections = {},
		EventConnections = {},
		InitialProperties = {},
		Instance = instance,
		Owner = ownerValue,
		PropertyChangeConnections = {},
		Props = {},
		RefTarget = nil,
		Tags = {},
	}

	instance.Parent = parent

	local success, failure = pcall(function()
		module.UpdateHost(handle, {}, elementValue.Props)
	end)

	if not success then
		lifecycle.Delete(ownerValue)
		error(failure, 0)
	end

	return handle
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a host and all renderer-owned resources.
--- @param handle hostHandle Host to delete.
--- @return boolean True when deletion occurred.
function module.DeleteHost(handle: hostHandle): boolean
	if handle.Owner.IsDeleted then
		return false
	end

	if handle.RefTarget then
		assignRef(handle.RefTarget, nil)
		handle.RefTarget = nil
	end

	table.clear(handle.Attributes)
	table.clear(handle.ChangeConnections)
	table.clear(handle.EventConnections)
	table.clear(handle.InitialProperties)
	table.clear(handle.PropertyChangeConnections)
	table.clear(handle.Props)
	table.clear(handle.Tags)

	return lifecycle.Delete(handle.Owner)
end

--————————————————————————————————————————————————————————————————————--

--- Replays the active host ref for StrictMode development checks.
--- Callback refs receive nil and then the current Instance again.
--- @param handle hostHandle Host whose ref should be replayed.
function module.ReplayRef(handle: hostHandle)
	if handle.Owner.IsDeleted or not handle.RefTarget then
		return
	end

	local target = handle.RefTarget
	assignRef(target, nil)
	assignRef(target, handle.Instance)
end

--————————————————————————————————————————————————————————————————————--

--- Updates one host using change-only property/event writes.
--- @param handle hostHandle Host being updated.
--- @param previousProps genericProps Previous props.
--- @param nextProps genericProps Next props.
function module.UpdateHost(
	handle: hostHandle,
	previousProps: elementModule.genericProps,
	nextProps: elementModule.genericProps
)
	if handle.Owner.IsDeleted then
		return
	end

	if handle.Instance.Parent == nil then
		return
	end

	if previousProps.Attributes ~= nextProps.Attributes then
		applyAttributes(handle, nextProps.Attributes)
	end

	if previousProps.Tags ~= nextProps.Tags then
		applyTags(handle, nextProps.Tags)
	end

	if previousProps.Ref ~= nextProps.Ref then
		applyRef(handle, nextProps.Ref)
	end

	if previousProps.OnPropertyChanged ~= nextProps.OnPropertyChanged then
		applyPropertyChanges(handle, nextProps.OnPropertyChanged)
	end

	for propName in previousProps do
		if nextProps[propName] ~= nil then
			continue
		end
		if isInternalProp(propName) then
			continue
		end

		if hostConfig.IsChange(propName) then
			applyChange(handle, propName, nil)
			continue
		end

		if hostConfig.IsEvent(propName) then
			applyEvent(handle, propName, nil)
			continue
		end

		resetProperty(handle, propName)
	end

	for propName, value in nextProps do
		if isInternalProp(propName) then
			continue
		end
		if previousProps[propName] == value then
			continue
		end

		if hostConfig.IsChange(propName) then
			applyChange(handle, propName, value)
			continue
		end

		if hostConfig.IsEvent(propName) then
			applyEvent(handle, propName, value)
			continue
		end

		applyProperty(handle, propName, value)
	end

	handle.Props = table.clone(nextProps)
end

--————————————————————————————————————————————————————————————————————--

return module
