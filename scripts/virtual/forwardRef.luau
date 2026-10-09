--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type ForwardRefTarget<T> = { current: T? } | ((value: T?) -> ())

--————————————————————————————————————————————————————————————————————--

--- Creates a component wrapper that forwards props.ref to the render callback.
--- @param render (props: P, ref: refTarget<R>?) -> any Render function receiving props and the forwarded ref.
--- @return any Forward-ref component function.
function module.new<P, R>(render: (props: P, ref: ForwardRefTarget<R>?) -> any): any
	return function(props: any)
		return render(props :: P, props.ref)
	end
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.forwardRef = module.new

return module
