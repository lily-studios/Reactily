--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType layerDefinition
export type layerDefinition = {
	DisplayOrder: number,
	IgnoreGuiInset: boolean?,
	ResetOnSpawn: boolean?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
}

--- @reactilyType layerManager
export type layerManager = {
	delete: () -> boolean,
	get: (name: string) -> ScreenGui?,
	getOrCreate: (name: string, definition: layerDefinition?) -> ScreenGui,
	isDeleted: () -> boolean,
	portal: (name: string, children: { any }, key: string?) -> elementModule.element,
}

--————————————————————————————————————————————————————————————————————--

local defaultDefinition: layerDefinition = {
	DisplayOrder = 0,
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}

--————————————————————————————————————————————————————————————————————--

local function resolveIgnoreGuiInset(definition: layerDefinition): boolean
	if definition.IgnoreGuiInset == nil then
		return true
	end

	return definition.IgnoreGuiInset
end

--————————————————————————————————————————————————————————————————————--

local function resolveResetOnSpawn(definition: layerDefinition): boolean
	if definition.ResetOnSpawn == nil then
		return false
	end

	return definition.ResetOnSpawn
end

--————————————————————————————————————————————————————————————————————--

local function resolveZIndexBehavior(definition: layerDefinition): Enum.ZIndexBehavior
	local zIndexBehavior = definition.ZIndexBehavior

	if zIndexBehavior then
		return zIndexBehavior
	end

	return Enum.ZIndexBehavior.Sibling
end

--————————————————————————————————————————————————————————————————————--

local function configure(screenGui: ScreenGui, definition: layerDefinition)
	local displayOrder = definition.DisplayOrder
	local ignoreGuiInset = resolveIgnoreGuiInset(definition)
	local resetOnSpawn = resolveResetOnSpawn(definition)
	local zIndexBehavior = resolveZIndexBehavior(definition)

	if screenGui.DisplayOrder ~= displayOrder then
		screenGui.DisplayOrder = displayOrder
	end

	if screenGui.IgnoreGuiInset ~= ignoreGuiInset then
		screenGui.IgnoreGuiInset = ignoreGuiInset
	end

	if screenGui.ResetOnSpawn ~= resetOnSpawn then
		screenGui.ResetOnSpawn = resetOnSpawn
	end

	if screenGui.ZIndexBehavior ~= zIndexBehavior then
		screenGui.ZIndexBehavior = zIndexBehavior
	end
end

--————————————————————————————————————————————————————————————————————--

local function copyDefinitions(definitions: { [string]: layerDefinition }?): { [string]: layerDefinition }
	local result: { [string]: layerDefinition } = {}

	if not definitions then
		return result
	end

	for name, definition in definitions do
		result[name] = definition
	end

	return result
end

--————————————————————————————————————————————————————————————————————--

--- Creates an owned ScreenGui layer manager for portals, overlays, modals, and tooltips.
--- @param parent Instance Parent that receives generated ScreenGui layers.
--- @param definitions {[string]: layerDefinition}? Initial named layers.
--- @return layerManager New layer manager.
function module.create(parent: Instance, definitions: { [string]: layerDefinition }?): layerManager
	assert(typeof(parent) == "Instance", "Reactily layer parent must be an Instance.")

	local configuredDefinitions = copyDefinitions(definitions)
	local layers: { [string]: ScreenGui } = {}

	local isDeleted = false

	--——————————————————————————————————————————————————————————————————--

	local function get(name: string): ScreenGui?
		assert(not isDeleted, "Reactily layer manager is deleted.")

		return layers[name]
	end

	--——————————————————————————————————————————————————————————————————--

	local function resolveDefinition(name: string, definition: layerDefinition?): layerDefinition
		if definition then
			return definition
		end

		local configuredDefinition = configuredDefinitions[name]

		if configuredDefinition then
			return configuredDefinition
		end

		return defaultDefinition
	end

	--——————————————————————————————————————————————————————————————————--

	local function getOrCreate(name: string, definition: layerDefinition?): ScreenGui
		assert(not isDeleted, "Reactily layer manager is deleted.")
		assert(name ~= "", "Reactily layer name cannot be empty.")

		local existing = layers[name]

		if existing then
			if definition then
				configure(existing, definition)
				configuredDefinitions[name] = definition
			end

			return existing
		end

		local settings = resolveDefinition(name, definition)

		local screenGui = Instance.new("ScreenGui")

		screenGui.Name = `ReactilyLayer_{name}`

		configure(screenGui, settings)

		screenGui.Parent = parent
		layers[name] = screenGui

		return screenGui
	end

	--——————————————————————————————————————————————————————————————————--

	local function portal(name: string, children: { any }, key: string?): elementModule.element
		assert(not isDeleted, "Reactily layer manager is deleted.")

		local target = getOrCreate(name, nil)

		return elementModule.createPortal(target, children, key)
	end

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, screenGui in layers do
			screenGui:Destroy()
		end

		table.clear(layers)
		table.clear(configuredDefinitions)

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--——————————————————————————————————————————————————————————————————--

	for name, definition in configuredDefinitions do
		getOrCreate(name, definition)
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		delete = delete,
		get = get,
		getOrCreate = getOrCreate,
		isDeleted = getIsDeleted,
		portal = portal,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
