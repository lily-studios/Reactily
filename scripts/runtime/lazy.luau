--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local resourceModule = require(script.Parent.resource)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

type component = (props: any) -> any
type resourceMap = { [component]: resourceModule.resource<component> }

--————————————————————————————————————————————————————————————————————--

local resources: resourceMap = {}

do
	local weakResources: any = resources

	setmetatable(weakResources, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Creates a component whose implementation is loaded on first render.
--- @param loader () -> T Loader returning a Reactily component. The loader may yield.
--- @return T Lazy component wrapper.
function module.new<T>(loader: () -> T): T
	local resource: resourceModule.resource<component> = resourceModule.new(function(): component
		local loaded = loader()

		assert(type(loaded) == "function", "Reactily.lazy loader must return a component function.")

		return loaded :: any
	end)

	local lazyComponent: component = function(props: any)
		local componentValue = resource.read()

		return componentValue(props)
	end

	resources[lazyComponent] = resource

	return lazyComponent :: any
end

--————————————————————————————————————————————————————————————————————--

--- Starts loading a lazy component before it is rendered.
--- @param componentValue component Component returned by Reactily.lazy.
--- @return boolean True when a lazy resource was found and preloaded.
function module.preload(componentValue: component): boolean
	local resource = resources[componentValue]
	if not resource then
		return false
	end

	resource.preload()

	return true
end

--————————————————————————————————————————————————————————————————————--

return module
