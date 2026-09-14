--!strict

-- provides immutable style composition helpers

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type style = {
	[string]: any,
}

--————————————————————————————————————————————————————————————————————--

--- Applies a style to a cloned properties table.
--- Style values override matching properties.
--- @param properties T Properties table to copy.
--- @param styleValue style Style values to apply.
--- @return T A new properties table with the style applied.
function module.apply<T>(properties: T, styleValue: style): T
	local output: any = table.clone(properties :: any)

	for property, value in styleValue do
		output[property] = value
	end

	return output :: T
end

--————————————————————————————————————————————————————————————————————--

--- Merges multiple styles into a new style.
--- Later styles override matching properties from earlier styles.
--- @param styles {style} Styles to merge in order.
--- @return style A new merged style.
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

--- Returns the supplied style when the condition is true.
--- @param condition boolean Whether the style should be included.
--- @param styleValue style Style to return when enabled.
--- @return style The supplied style or an empty style.
function module.when(condition: boolean, styleValue: style): style
	if not condition then
		return {}
	end

	return styleValue
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy of a style without the specified property.
--- @param styleValue style Style to copy.
--- @param property string Property to remove.
--- @return style A new style without the property.
function module.without(styleValue: style, property: string): style
	local output = table.clone(styleValue)

	output[property] = nil

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Returns a copy of a style with the specified property replaced or added.
--- @param styleValue style Style to copy.
--- @param property string Property to set.
--- @param value any Value assigned to the property.
--- @return style A new style containing the property.
function module.withProperty(styleValue: style, property: string, value: any): style
	local output = table.clone(styleValue)

	output[property] = value

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
