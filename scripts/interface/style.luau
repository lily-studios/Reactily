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

--- @reactilyType VariantStyle
export type variantStyle = {
	Base: style?,
	Variants: { [string]: style }?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a frozen reusable style table.
--- @param values style Style values.
--- @return style Frozen style.
function module.Create(values: style): style
	return table.freeze(table.clone(values))
end

--————————————————————————————————————————————————————————————————————--

--- Resolves a base style and named variant into one style table.
--- @param definition variantStyle Style definition.
--- @param variant string? Variant name.
--- @return style Resolved style.
function module.Variant(definition: variantStyle, variant: string?): style
	local output: style = {}

	if definition.Base then
		for property, value in definition.Base do
			output[property] = value
		end
	end

	if variant == nil or definition.Variants == nil then
		return output
	end

	local selected = definition.Variants[variant]
	if not selected then
		return output
	end

	for property, value in selected do
		output[property] = value
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Applies a style to a property table without mutating the original table.
--- @param properties T Property table to copy.
--- @param styleValue style Style values to apply to the copied table.
--- @return T Copied property table with the style applied.
function module.Apply<T>(properties: T, styleValue: style): T
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
function module.Merge(styles: { style }): style
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
function module.When(condition: boolean, styleValue: style): style
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
function module.Without(styleValue: style, property: string): style
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
function module.WithProperty(styleValue: style, property: string, value: any): style
	local output = table.clone(styleValue)

	output[property] = value

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
