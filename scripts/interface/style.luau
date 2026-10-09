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

export type Style = {
	[string]: any,
}

--————————————————————————————————————————————————————————————————————--

export type VariantStyle = {
	base: Style?,
	variants: { [string]: Style }?,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a frozen reusable style table.
--- @param values style Style values.
--- @return style Frozen style.
function module.create(values: Style): Style
	return table.freeze(table.clone(values))
end

--————————————————————————————————————————————————————————————————————--

--- Resolves a base style and named variant into one style table.
--- @param definition variantStyle Style definition.
--- @param variant string? Variant name.
--- @return style Resolved style.
function module.variant(definition: VariantStyle, variant: string?): Style
	local output: Style = {}

	if definition.base then
		for property, value in definition.base do
			output[property] = value
		end
	end

	if variant == nil or definition.variants == nil then
		return output
	end

	local selected = definition.variants[variant]
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
function module.apply<T>(properties: T, styleValue: Style): T
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
function module.merge(styles: { Style }): Style
	local output: Style = {}

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
function module.when(condition: boolean, styleValue: Style): Style
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
function module.without(styleValue: Style, property: string): Style
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
function module.withProperty(styleValue: Style, property: string, value: any): Style
	local output = table.clone(styleValue)

	output[property] = value

	return output
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.applyStyle = module.apply
module.createStyle = module.merge

return module
