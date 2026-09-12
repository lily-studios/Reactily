--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type style = {
	[string]: any,
}

--————————————————————————————————————————————————————————————————————--

function module.apply<T>(properties: T, styleValue: style): T
	local output: any = table.clone(properties :: any)

	for property, value in styleValue do
		output[property] = value
	end

	return output :: T
end
--————————————————————————————————————————————————————————————————————--

function module.merge(styles: {style}): style
	local output: style = {}

	for _, styleValue in styles do
		for property, value in styleValue do
			output[property] = value
		end
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.when(condition: boolean, styleValue: style): style
	if not condition then return {} end

	return styleValue
end

--————————————————————————————————————————————————————————————————————--

function module.without(styleValue: style, property: string): style
	local output = table.clone(styleValue)
	output[property] = nil

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.withProperty(styleValue: style, property: string, value: any): style
	local output = table.clone(styleValue)
	output[property] = value

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
