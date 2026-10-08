--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.element)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

--- Counts normalized Reactily children.
--- @param children {any} Child elements or nested child arrays.
--- @return number Normalized child count.
function module.count(children: { any }): number
	return #elementModule.flattenChildren(children)
end

--————————————————————————————————————————————————————————————————————--

--- Invokes a callback for every normalized child.
--- @param children {any} Child elements or nested child arrays.
--- @param callback (child: element, index: number) -> () Callback for each child.
function module.forEach(children: { any }, callback: (child: elementModule.element, index: number) -> ())
	local normalized = elementModule.flattenChildren(children)

	for index, child in normalized do
		callback(child, index)
	end
end

--————————————————————————————————————————————————————————————————————--

--- Maps normalized children and flattens returned child arrays.
--- @param children {any} Child elements or nested child arrays.
--- @param callback (child: element, index: number) -> any Mapping callback.
--- @return {element} Normalized mapped children.
function module.map(
	children: { any },
	callback: (child: elementModule.element, index: number) -> any
): { elementModule.element }
	local normalized = elementModule.flattenChildren(children)
	local mapped: { any } = table.create(#normalized)

	for index, child in normalized do
		mapped[index] = callback(child, index)
	end

	return elementModule.flattenChildren(mapped)
end

--————————————————————————————————————————————————————————————————————--

--- Returns the only normalized child and errors when the count differs from one.
--- @param children {any} Child elements or nested child arrays.
--- @return element The only child.
function module.only(children: { any }): elementModule.element
	local normalized = elementModule.flattenChildren(children)

	assert(#normalized == 1, `Reactily.Children.only expected one child, received {#normalized}.`)

	return normalized[1]
end

--————————————————————————————————————————————————————————————————————--

--- Flattens nested children into a new ordered array.
--- @param children {any} Child elements or nested child arrays.
--- @return {element} Normalized children.
function module.toArray(children: { any }): { elementModule.element }
	return elementModule.flattenChildren(children)
end

--————————————————————————————————————————————————————————————————————--

return module
