--!strict

-- creates, updates, and deletes Roblox host Instances for Reactily elements

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

local function applyAttributes(
	handle: hostHandle,
	attributes: elementModule.attributeMap?
)
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

local function applyEvent(
	handle: hostHandle,
	propName: string,
	callback: any
)
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

	assert(
		success,
		`Reactily event "{eventName}" is invalid for {handle.instance.ClassName}: {signalOrFailure}`
	)

	assert(
		typeof(signalOrFailure) == "RBXScriptSignal",
		`Reactily event "{eventName}" is not a signal on {handle.instance.ClassName}.`
	)

	handle.eventConnections[propName] = lifecycle.connect(
		handle.owner,
		signalOrFailure,
		callback
	)
end

--————————————————————————————————————————————————————————————————————--

local function applyProperty(
	handle: hostHandle,
	propName: string,
	value: any
)
	local propertyName = hostConfig.getPropertyName(propName)

	assert(
		propertyName,
		`Reactily prop "{propName}" is not supported by the host renderer.`
	)

	local target = handle.instance :: any

	local readSuccess, currentOrFailure = pcall(function(): any
		return target[propertyName]
	end)

	assert(
		readSuccess,
		`Reactily prop "{propName}" is invalid for {handle.instance.ClassName}: {currentOrFailure}`
	)

	if currentOrFailure == value then return end

	if not handle.initialProperties[propName] then
		handle.initialProperties[propName] = {
			value = currentOrFailure,
		}
	end

	local writeSuccess, writeFailure = pcall(function()
		target[propertyName] = value
	end)

	assert(
		writeSuccess,
		`Reactily could not set "{propName}" on {handle.instance.ClassName}: {writeFailure}`
	)
end

--————————————————————————————————————————————————————————————————————--

local function applyRef(
	handle: hostHandle,
	callback: ((Instance?) -> ())?
)
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
			warn(
				`Reactily could not reset "{propName}" on {handle.instance.ClassName}: {writeFailure}`
			)
		end
	end

	handle.initialProperties[propName] = nil
end

--————————————————————————————————————————————————————————————————————--

--- Creates and mounts a Roblox host Instance for a Reactily host element.
--- The returned handle owns the Instance, events, attributes, tags, refs, and lifecycle state.
--- @param parent Instance Parent that receives the created Roblox Instance.
--- @param elementValue elementModule.element Host element describing the Instance class and initial props.
--- @return hostHandle Handle used to update or delete the mounted host.
function module.createHost(
	parent: Instance,
	elementValue: elementModule.element
): hostHandle
	assert(
		elementValue.kind == "host",
		"Reactily renderer can only create host elements."
	)

	local ownerValue = lifecycle.new()
	local instance = lifecycle.trackInstance(
		ownerValue,
		Instance.new(elementValue.className)
	)

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

--- Deletes a mounted host and all resources owned by its lifecycle.
--- Any active ref callback receives nil before the host is destroyed.
--- @param handle hostHandle Host handle to delete.
--- @return boolean Whether deletion occurred.
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

local function updateMetadata(
	handle: hostHandle,
	previousProps: elementModule.genericProps,
	nextProps: elementModule.genericProps
)
	if previousProps.attributes ~= nextProps.attributes then
		applyAttributes(handle, nextProps.attributes)
	end

	if previousProps.ref ~= nextProps.ref then
		applyRef(handle, nextProps.ref)
	end

	if previousProps.tags ~= nextProps.tags then
		applyTags(handle, nextProps.tags)
	end
end

--————————————————————————————————————————————————————————————————————--

--- Removes a host prop that no longer exists in the next render.
--- Events are disconnected while regular properties are restored to their initial values.
--- @param handle hostHandle Host receiving the prop removal.
--- @param propName string Reactily prop name being removed.
local function removeProp(
	handle: hostHandle,
	propName: string
)
	if isInternalProp(propName) then return end

	if hostConfig.isEvent(propName) then
		applyEvent(handle, propName, nil)

		return
	end

	resetProperty(handle, propName)
end

--————————————————————————————————————————————————————————————————————--

--- Applies a changed host prop.
--- Internal props are ignored and event props are connected through the host lifecycle.
--- @param handle hostHandle Host receiving the prop update.
--- @param propName string Reactily prop name being updated.
--- @param value any New prop value.
local function updateProp(
	handle: hostHandle,
	propName: string,
	value: any
)
	if isInternalProp(propName) then return end

	if hostConfig.isEvent(propName) then
		applyEvent(handle, propName, value)

		return
	end

	applyProperty(handle, propName, value)
end

--————————————————————————————————————————————————————————————————————--

--- Applies changed props to an existing mounted host.
--- Removed props are reset while unchanged props are skipped.
--- @param handle hostHandle Mounted host being updated.
--- @param previousProps elementModule.genericProps Props from the previous render.
--- @param nextProps elementModule.genericProps Props from the next render.
function module.updateHost(
	handle: hostHandle,
	previousProps: elementModule.genericProps,
	nextProps: elementModule.genericProps
)
	if handle.owner.isDeleted then return end

	updateMetadata(handle, previousProps, nextProps)

	for propName in previousProps do
		if nextProps[propName] ~= nil then continue end

		removeProp(handle, propName)
	end

	for propName, value in nextProps do
		if previousProps[propName] == value then continue end

		updateProp(handle, propName, value)
	end

	handle.props = table.clone(nextProps)
end

--————————————————————————————————————————————————————————————————————--

return module