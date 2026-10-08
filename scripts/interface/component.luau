--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)
local propsModule = require(script.Parent.props)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- @reactilyType componentOptions
export type componentOptions<P> = {
	defaults: P?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a reusable function component with optional default props.
--- @param render (props: P) -> element? Component render callback.
--- @param options componentOptions<P>? Component defaults.
--- @return component<P> Reactily function component.
function module.create<P>(
	render: (props: P) -> elementModule.element?,
	options: componentOptions<P>?
): elementModule.component<P>
	if not options or options.defaults == nil then
		return render
	end

	local defaults = options.defaults :: any

	return function(props: P): elementModule.element?
		local merged = propsModule.defaults(props, defaults)
		return render(merged)
	end
end

--————————————————————————————————————————————————————————————————————--

--- Wraps a component with default props while preserving function-component behavior.
--- @param componentValue component<P> Existing component.
--- @param defaults P Defaults applied when a prop is absent.
--- @return component<P> Wrapped component.
function module.withDefaults<P>(componentValue: elementModule.component<P>, defaults: P): elementModule.component<P>
	return module.create(componentValue, {
		defaults = defaults,
	})
end

--————————————————————————————————————————————————————————————————————--

return module
