--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local compare = require(script.Parent.Parent.core.compare)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type Comparator = (previousProps: { [string]: any }, nextProps: { [string]: any }) -> boolean

type Component = (props: any) -> any
type ComparatorMap = { [Component]: Comparator }

--————————————————————————————————————————————————————————————————————--

local comparators: ComparatorMap = {}

do
	local weakComparators: any = comparators

	setmetatable(weakComparators, {
		__mode = "k",
	})
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether a component has been wrapped with Reactily.memo.
--- @param componentValue component Component function to inspect.
--- @return boolean True when the component has memo metadata.
function module.isMemo(componentValue: Component): boolean
	return comparators[componentValue] ~= nil
end

--————————————————————————————————————————————————————————————————————--

--- Returns whether a memoized component should rerender for new props.
--- @param componentValue component Memoized component.
--- @param previousProps {[string]: any} Previous props.
--- @param nextProps {[string]: any} Next props.
--- @return boolean True when reconciliation should rerender the component.
function module.shouldUpdate(
	componentValue: Component,
	previousProps: { [string]: any },
	nextProps: { [string]: any }
): boolean
	local comparatorValue = comparators[componentValue]
	if not comparatorValue then
		return true
	end

	return not comparatorValue(previousProps, nextProps)
end

--————————————————————————————————————————————————————————————————————--

--- Wraps a component with a memoization comparator.
--- @param componentValue T Component function to memoize.
--- @param comparatorValue comparator? Optional equality function. Defaults to shallow equality.
--- @return T Stable memoized component wrapper.
function module.wrap<T>(componentValue: T, comparatorValue: Comparator?): T
	assert(type(componentValue) == "function", "Reactily.memo expects a component function.")

	local source: any = componentValue
	local wrapped: any = function(props: any)
		return source(props)
	end

	comparators[wrapped] = comparatorValue or compare.shallowEqual

	return wrapped
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.memo = module.wrap

return module
