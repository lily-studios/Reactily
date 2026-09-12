--!strict

-- applies Reactily host props to Roblox Instances with change-only writes

local collectionService = game:GetService("CollectionService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")
local virtual = script.Parent.Parent:WaitForChild("virtual")

local elementModule = require(virtual:WaitForChild("element"))
local hostConfig = require(script.Parent:WaitForChild("hostConfig"))
local lifecycle = require(core:WaitForChild("lifecycle"))

--————————————————————————————————————————————————————————————————————--

type initialProperty = {
	value: any,
}

export type hostHandle = {
	attributes: elementModule.attributeMap,
	eventConnections: {[string]: RBXScriptConnection},
	initialProperties: {[string]: initialProperty},
	instance: Instance,
	owner: lifecycle.owner,
	props: elementModule.genericProps,
	refCallback: ((Instance?) -> ())?,
	tags: {[string]: boolean},
}

--————————————————————————————————————————————————————————————————————--

local function applyAttributes(handle: hostHandle, attributes: elementModule.attributeMap?)
	local nextAttributes: elementModule.attributeMap = {}

	if attributes then
		nextAttributes = attributes
	end

	for name in handle.attributes do
		if nextAttributes[name] ~= nil then continue end
		if handle.instance:GetAttribute(name) == nil then continue end

		handle.instance:SetAttribute(name, nil)
	end

	for name, value in nextAttributes do
		if handle.instance:GetAttribute(name) == value then continue end

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

	if callback == nil then return end

	local success, signalOrFailure = pcall(function(): any
		return (handle.instance :: any)[eventName]
	end)

	assert(success, `Reactily event "{eventName}" is invalid for {handle.instance.ClassName}: {signalOrFailure}`)
	assert(typeof(signalOrFailure) == "RBXScriptSignal", `Reactily event "{eventName}" is not a signal on {handle.instance.ClassName}.`)

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
	if currentOrFailure == value then return end

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

local function applyRef(handle: hostHandle, callback: ((Instance?) -> ())?)
	if handle.refCallback == callback then return end

	if handle.refCallback then
		handle.refCallback(nil)
	end

	handle.refCallback = callback

	if callback then
		callback(handle.instance)
	end
end

--————————————————————————————————————————————————————————————————————--

local function applyTags(handle: hostHandle, tags: {string}?)
	local nextTags: {[string]: boolean} = {}

	if tags then
		for _, tag in tags do
			nextTags[tag] = true
		end
	end

	for tag in handle.tags do
		if nextTags[tag] then continue end
		if not collectionService:HasTag(handle.instance, tag) then continue end

		collectionService:RemoveTag(handle.instance, tag)
	end

	for tag in nextTags do
		if collectionService:HasTag(handle.instance, tag) then continue end

		collectionService:AddTag(handle.instance, tag)
	end

	handle.tags = nextTags
end

--————————————————————————————————————————————————————————————————————--

local function isInternalProp(propName: string): boolean
	if propName == "attributes" then return true end
	if propName == "children" then return true end
	if propName == "key" then return true end
	if propName == "ref" then return true end
	if propName == "tags" then return true end

	return false
end

--————————————————————————————————————————————————————————————————————--

local function resetProperty(handle: hostHandle, propName: string)
	local initial = handle.initialProperties[propName]
	if not initial then return end

	local propertyName = hostConfig.getPropertyName(propName)
	if not propertyName then return end

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
		props = {},
		refCallback = nil,
		tags = {},
	}

	instance.Parent = parent
	module.updateHost(handle, {}, elementValue.props)

	return handle
end

--————————————————————————————————————————————————————————————————————--

function module.deleteHost(handle: hostHandle): boolean
	if handle.owner.isDeleted then return false end

	if handle.refCallback then
		handle.refCallback(nil)
		handle.refCallback = nil
	end

	table.clear(handle.attributes)
	table.clear(handle.eventConnections)
	table.clear(handle.initialProperties)
	table.clear(handle.props)
	table.clear(handle.tags)

	return lifecycle.delete(handle.owner)
end

--————————————————————————————————————————————————————————————————————--

function module.updateHost(
	handle: hostHandle,
	previousProps: elementModule.genericProps,
	nextProps: elementModule.genericProps
)
	if handle.owner.isDeleted then return end

	if previousProps.attributes ~= nextProps.attributes then
		applyAttributes(handle, nextProps.attributes)
	end

	if previousProps.tags ~= nextProps.tags then
		applyTags(handle, nextProps.tags)
	end

	if previousProps.ref ~= nextProps.ref then
		applyRef(handle, nextProps.ref)
	end

	for propName in previousProps do
		if nextProps[propName] ~= nil then continue end
		if isInternalProp(propName) then continue end

		if hostConfig.isEvent(propName) then
			applyEvent(handle, propName, nil)
			continue
		end

		resetProperty(handle, propName)
	end

	for propName, value in nextProps do
		if isInternalProp(propName) then continue end
		if previousProps[propName] == value then continue end

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
