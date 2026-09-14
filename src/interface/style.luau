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

export type style = {
	[string]: any,
}

--————————————————————————————————————————————————————————————————————--

--- Applies a style to a property table without mutating the original table.
--- @param properties T Property table to copy.
--- @param styleValue style Style values to apply to the copied table.
--- @return T Copied property table with the style applied.
function module.apply<T>(properties: T, styleValue: style): T
	local output: any = table.clone(properties :: any)

	for property, value in styleValue do
		output[property] = value
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Merges multiple style tables without mutating the input styles.
--- @param styles {style} Ordered style tables to merge.
--- @return style New style containing the merged properties.
function module.merge(styles: { style }): style
	local output: style = {}

	for _, styleValue in styles do
		for property, value in styleValue do
			output[property] = value
		end
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns a style only when the supplied condition is true.
--- @param condition boolean Whether the style should be included.
--- @param styleValue style Style to conditionally return.
--- @return style Supplied style when enabled, otherwise an empty style.
function module.when(condition: boolean, styleValue: style): style
	if not condition then
		return {}
	end

	return styleValue
end

--————————————————————————————————————————————————————————————————————--

--- Creates a style without one specified property.
--- @param styleValue style Style to copy.
--- @param property string Property to omit from the copied style.
--- @return style Copied style without the specified property.
function module.without(styleValue: style, property: string): style
	local output = table.clone(styleValue)

	output[property] = nil

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates a style with one property assigned to a new value.
--- @param styleValue style Style to copy.
--- @param property string Property to assign.
--- @param value any Value to assign to the property.
--- @return style Copied style containing the new property value.
function module.withProperty(styleValue: style, property: string, value: any): style
	local output = table.clone(styleValue)

	output[property] = value

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
