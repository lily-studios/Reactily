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
	value: any,
}

export type hostHandle = {
	attributes: elementModule.attributeMap,
	eventConnections: { [string]: RBXScriptConnection },
	initialProperties: { [string]: initialProperty },
	instance: Instance,
	owner: lifecycle.owner,
	propertyChangeConnections: { [string]: RBXScriptConnection },
	props: elementModule.genericProps,
	refCallback: ((Instance?) -> ())?,
	tags: { [string]: boolean },
}

--————————————————————————————————————————————————————————————————————--

local function applyAttributes(handle: hostHandle, attributes: elementModule.attributeMap?)
	local nextAttributes: elementModule.attributeMap = {}

	if attributes then
		nextAttributes = attributes
	end

	for name in handle.attributes do
		if nextAttributes[name] ~= nil then
			continue
		end
		if handle.instance:GetAttribute(name) == nil then
			continue
		end

		handle.instance:SetAttribute(name, nil)
	end

	for name, value in nextAttributes do
		if handle.instance:GetAttribute(name) == value then
			continue
		end

		handle.instance:SetAttribute(name, value)
	end

	handle.attributes = table.clone(nextAttributes)
end

--————————————————————————————————————————————————————————————————————--

local function applyEvent(handle: hostHandle, propName: string, callback: any)
	local eventName = hostConfig.getEventName(propName)
	assert(eventName, `Reactily event prop "{propName}" is not registered.`)

	local previous = handle.eventConnections[propName]

	if previous then
		lifecycle.disconnect(handle.owner, previous)
		handle.eventConnections[propName] = nil
	end

	if callback == nil then
		return
	end

	local success, signalOrFailure = pcall(function(): any
		return (handle.instance :: any)[eventName]
	end)

	assert(success, `Reactily event "{eventName}" is invalid for {handle.instance.ClassName}: {signalOrFailure}`)
	assert(
		typeof(signalOrFailure) == "RBXScriptSignal",
		`Reactily event "{eventName}" is not a signal on {handle.instance.ClassName}.`
	)

	handle.eventConnections[propName] = lifecycle.connect(handle.owner, signalOrFailure, callback)
end

--————————————————————————————————————————————————————————————————————--

local function applyProperty(handle: hostHandle, propName: string, value: any)
	local propertyName = hostConfig.getPropertyName(propName)
	assert(propertyName, `Reactily prop "{propName}" is not supported by the host renderer.`)

	local target = handle.instance :: any
	local readSuccess, currentOrFailure = pcall(function(): any
		return target[propertyName]
	end)

	assert(readSuccess, `Reactily prop "{propName}" is invalid for {handle.instance.ClassName}: {currentOrFailure}`)
	if currentOrFailure == value then
		return
	end

	if not handle.initialProperties[propName] then
		handle.initialProperties[propName] = {
			value = currentOrFailure,
		}
	end

	local writeSuccess, writeFailure = pcall(function()
		target[propertyName] = value
	end)

	assert(writeSuccess, `Reactily could not set "{propName}" on {handle.instance.ClassName}: {writeFailure}`)
end

--————————————————————————————————————————————————————————————————————--

local function applyPropertyChanges(handle: hostHandle, callbacks: { [string]: (value: any) -> () }?)
	for _, connection in handle.propertyChangeConnections do
		lifecycle.disconnect(handle.owner, connection)
	end

	table.clear(handle.propertyChangeConnections)
	if not callbacks then
		return
	end

	for propertyName, callback in callbacks do
		assert(type(propertyName) == "string", "Reactily property-change names must be strings.")
		assert(type(callback) == "function", "Reactily property-change callbacks must be functions.")

		local success, signalOrFailure = pcall(function(): RBXScriptSignal
			return handle.instance:GetPropertyChangedSignal(propertyName)
		end)

		assert(
			success,
			`Reactily property "{propertyName}" is invalid for {handle.instance.ClassName}: {signalOrFailure}`
		)

		local propertySignal = signalOrFailure :: RBXScriptSignal
		handle.propertyChangeConnections[propertyName] = lifecycle.connect(handle.owner, propertySignal, function()
			local target = handle.instance :: any
			callback(target[propertyName])
		end)
	end
end

--————————————————————————————————————————————————————————————————————--

local function applyRef(handle: hostHandle, callback: ((Instance?) -> ())?)
	if handle.refCallback == callback then
		return
	end

	if handle.refCallback then
		handle.refCallback(nil)
	end

	handle.refCallback = callback

	if callback then
		callback(handle.instance)
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

	for tag in handle.tags do
		if nextTags[tag] then
			continue
		end
		if not collectionService:HasTag(handle.instance, tag) then
			continue
		end

		collectionService:RemoveTag(handle.instance, tag)
	end

	for tag in nextTags do
		if collectionService:HasTag(handle.instance, tag) then
			continue
		end

		collectionService:AddTag(handle.instance, tag)
	end

	handle.tags = nextTags
end

--————————————————————————————————————————————————————————————————————--

local function isInternalProp(propName: string): boolean
	if propName == "attributes" then
		return true
	end
	if propName == "children" then
		return true
	end
	if propName == "key" then
		return true
	end
	if propName == "onPropertyChanged" then
		return true
	end
	if propName == "ref" then
		return true
	end
	if propName == "tags" then
		return true
	end

	return false
end

--————————————————————————————————————————————————————————————————————--

local function resetProperty(handle: hostHandle, propName: string)
	local initial = handle.initialProperties[propName]
	if not initial then
		return
	end

	local propertyName = hostConfig.getPropertyName(propName)
	if not propertyName then
		return
	end

	local target = handle.instance :: any
	local readSuccess, currentValue = pcall(function(): any
		return target[propertyName]
	end)

	if not readSuccess then
		handle.initialProperties[propName] = nil
		return
	end

	if currentValue ~= initial.value then
		local writeSuccess, writeFailure = pcall(function()
			target[propertyName] = initial.value
		end)

		if not writeSuccess then
			warn(`Reactily could not reset "{propName}" on {handle.instance.ClassName}: {writeFailure}`)
		end
	end

	handle.initialProperties[propName] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Creates and owns one Roblox host Instance for a virtual host element.
--- @param parent Instance Parent receiving the new host Instance.
--- @param elementValue element Reactily host element.
--- @return hostHandle Owned host handle.
function module.createHost(parent: Instance, elementValue: elementModule.element): hostHandle
	assert(elementValue.kind == "host", "Reactily renderer can only create host elements.")

	local ownerValue = lifecycle.new()
	local instance = lifecycle.trackInstance(ownerValue, Instance.new(elementValue.className))
	local handle: hostHandle = {
		attributes = {},
		eventConnections = {},
		initialProperties = {},
		instance = instance,
		owner = ownerValue,
		propertyChangeConnections = {},
		props = {},
		refCallback = nil,
		tags = {},
	}

	instance.Parent = parent
	module.updateHost(handle, {}, elementValue.props)
	return handle
end

--————————————————————————————————————————————————————————————————————--

--- Deletes a host and all renderer-owned resources.
--- @param handle hostHandle Host to delete.
--- @return boolean True when deletion occurred.
function module.deleteHost(handle: hostHandle): boolean
	if handle.owner.isDeleted then
		return false
	end

	if handle.refCallback then
		handle.refCallback(nil)
		handle.refCallback = nil
	end

	table.clear(handle.attributes)
	table.clear(handle.eventConnections)
	table.clear(handle.initialProperties)
	table.clear(handle.propertyChangeConnections)
	table.clear(handle.props)
	table.clear(handle.tags)

	return lifecycle.delete(handle.owner)
end

--————————————————————————————————————————————————————————————————————--

--- Updates one host using change-only property/event writes.
--- @param handle hostHandle Host being updated.
--- @param previousProps genericProps Previous props.
--- @param nextProps genericProps Next props.
function module.updateHost(
	handle: hostHandle,
	previousProps: elementModule.genericProps,
	nextProps: elementModule.genericProps
)
	if handle.owner.isDeleted then
		return
	end

	if handle.instance.Parent == nil then
		return
	end

	if previousProps.attributes ~= nextProps.attributes then
		applyAttributes(handle, nextProps.attributes)
	end

	if previousProps.tags ~= nextProps.tags then
		applyTags(handle, nextProps.tags)
	end

	if previousProps.ref ~= nextProps.ref then
		applyRef(handle, nextProps.ref)
	end

	if previousProps.onPropertyChanged ~= nextProps.onPropertyChanged then
		applyPropertyChanges(handle, nextProps.onPropertyChanged)
	end

	for propName in previousProps do
		if nextProps[propName] ~= nil then
			continue
		end
		if isInternalProp(propName) then
			continue
		end

		if hostConfig.isEvent(propName) then
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

		if hostConfig.isEvent(propName) then
			applyEvent(handle, propName, value)
			continue
		end

		applyProperty(handle, propName, value)
	end

	handle.props = table.clone(nextProps)
end

--————————————————————————————————————————————————————————————————————--

return module
