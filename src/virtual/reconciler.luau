--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}
local internals = {}

--————————————————————————————————————————————————————————————————————--

local runtime = script.Parent.Parent:WaitForChild("runtime")
local state = script.Parent.Parent:WaitForChild("state")

local elementModule = require(script.Parent:WaitForChild("element"))
local hooks = require(state:WaitForChild("hooks"))
local renderer = require(runtime:WaitForChild("renderer"))

--————————————————————————————————————————————————————————————————————--

export type reconcileOptions = {
	requestRender: () -> (),
}

export type runtimeNode = {
	children: {runtimeNode},
	element: elementModule.element,
	hookContext: hooks.componentContext?,
	host: renderer.hostHandle?,
	parent: Instance,
}

--————————————————————————————————————————————————————————————————————--

local function getElementKey(elementValue: elementModule.element): string?
	return elementValue.key
end

--————————————————————————————————————————————————————————————————————--

function internals.deleteNode(node: runtimeNode)
	for index = #node.children, 1, -1 do
		internals.deleteNode(node.children[index])
	end

	table.clear(node.children)

	if node.hookContext then
		hooks.deleteContext(node.hookContext)
		node.hookContext = nil
	end

	if node.host then
		renderer.deleteHost(node.host)
		node.host = nil
	end
end

--————————————————————————————————————————————————————————————————————--

function internals.mount(
	parent: Instance,
	elementValue: elementModule.element,
	options: reconcileOptions
): runtimeNode
	local node: runtimeNode = {
		children = {},
		element = elementValue,
		hookContext = nil,
		host = nil,
		parent = parent,
	}

	if elementValue.kind == "host" then
		local host = renderer.createHost(parent, elementValue)
		node.host = host

		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(host.instance, child, options)
		end

		return node
	end

	if elementValue.kind == "component" then
		local hookContext = hooks.newContext(options.requestRender)
		node.hookContext = hookContext

		local rendered = internals.renderComponent(elementValue, hookContext)

		if rendered then
			node.children[1] = internals.mount(parent, rendered, options)
		end

		hooks.flushEffects(hookContext)

		return node
	end

	if elementValue.kind == "portal" then
		for _, child in elementValue.children do
			node.children[#node.children + 1] = internals.mount(elementValue.target, child, options)
		end

		return node
	end

	for _, child in elementValue.children do
		node.children[#node.children + 1] = internals.mount(parent, child, options)
	end

	return node
end

--————————————————————————————————————————————————————————————————————--

function internals.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	if not currentNode and not nextElement then return nil end

	if not currentNode then
	assert(nextElement, "[Reactily] Reconcile requires a next element when no current node exists.")
		return internals.mount(parent, nextElement, options)
	end

	if not nextElement then
		internals.deleteNode(currentNode)
		return nil
	end

	if not internals.sameIdentity(currentNode.element, nextElement) then
		internals.deleteNode(currentNode)
		return internals.mount(parent, nextElement, options)
	end

	local previousElement = currentNode.element
	currentNode.element = nextElement
	currentNode.parent = parent

	if nextElement.kind == "host" then
		local host = currentNode.host
		assert(host, "[Reactily] Host runtime node is missing its host handle.")
		assert(previousElement.kind == "host", "[Reactily] Host identity changed unexpectedly.")

		renderer.updateHost(host, previousElement.props, nextElement.props)
		currentNode.children = internals.reconcileChildren(
			host.instance,
			currentNode.children,
			nextElement.children,
			options
		)

		return currentNode
	end

	if nextElement.kind == "component" then
		local hookContext = currentNode.hookContext
		assert(hookContext, "Reactily component runtime node is missing hook context.")

		local rendered = internals.renderComponent(nextElement, hookContext)
		local currentChild = currentNode.children[1]
		local nextChild = internals.reconcile(parent, currentChild, rendered, options)

		table.clear(currentNode.children)

		if nextChild then
			currentNode.children[1] = nextChild
		end

		hooks.flushEffects(hookContext)

		return currentNode
	end

	if nextElement.kind == "portal" then
		currentNode.children = internals.reconcileChildren(
			nextElement.target,
			currentNode.children,
			nextElement.children,
			options
		)

		return currentNode
	end

	currentNode.children = internals.reconcileChildren(
		parent,
		currentNode.children,
		nextElement.children,
		options
	)

	return currentNode
end

--————————————————————————————————————————————————————————————————————--

function internals.reconcileChildren(
	parent: Instance,
	currentChildren: {runtimeNode},
	nextChildren: {elementModule.element},
	options: reconcileOptions
): {runtimeNode}
	local currentByKey: {[string]: runtimeNode} = {}
	local currentWithoutKey: {runtimeNode} = {}
	local nextKeys: {[string]: boolean} = {}
	local output: {runtimeNode} = table.create(#nextChildren)
	local usedNodes: {[runtimeNode]: boolean} = {}

	for _, currentNode in currentChildren do
		local key = getElementKey(currentNode.element)

		if not key then
			currentWithoutKey[#currentWithoutKey + 1] = currentNode
			continue
		end

		assert(not currentByKey[key], `Reactily current children contain duplicate key "{key}".`)
		currentByKey[key] = currentNode
	end

	local unkeyedIndex = 0

	for _, nextElement in nextChildren do
		local key = getElementKey(nextElement)
		local currentNode: runtimeNode? = nil

		if key then
			assert(not nextKeys[key], `Reactily next children contain duplicate key "{key}".`)
			nextKeys[key] = true
			currentNode = currentByKey[key]
		end

		if not key then
			unkeyedIndex += 1
			currentNode = currentWithoutKey[unkeyedIndex]
		end

		if currentNode then
			usedNodes[currentNode] = true
		end

		local nextNode = internals.reconcile(parent, currentNode, nextElement, options)
		if not nextNode then continue end

		output[#output + 1] = nextNode
	end

	for _, currentNode in currentChildren do
		if usedNodes[currentNode] then continue end

		internals.deleteNode(currentNode)
	end

	table.clear(currentByKey)
	table.clear(currentChildren)
	table.clear(currentWithoutKey)
	table.clear(nextKeys)
	table.clear(usedNodes)

	return output
end

--————————————————————————————————————————————————————————————————————--

function internals.renderComponent(
	elementValue: elementModule.element,
	context: hooks.componentContext
): elementModule.element?
	assert(elementValue.kind == "component", "Reactily component renderer requires a component element.")

	local props = table.clone(elementValue.props)
	props.children = elementValue.children

	hooks.beginRender(context)

	local success, result = pcall(elementValue.component, props)

	hooks.endRender(context, success)

	if not success then
		error(result)
	end

	return result
end

--————————————————————————————————————————————————————————————————————--

function internals.sameIdentity(current: elementModule.element, nextValue: elementModule.element): boolean
	if current.kind ~= nextValue.kind then return false end
	if current.key ~= nextValue.key then return false end

	if current.kind == "host" and nextValue.kind == "host" then
		return current.className == nextValue.className
	end

	if current.kind == "component" and nextValue.kind == "component" then
		return current.component == nextValue.component
	end

	if current.kind == "portal" and nextValue.kind == "portal" then
		return current.target == nextValue.target
	end

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.delete(node: runtimeNode?): boolean
	if not node then return false end

	internals.deleteNode(node)

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.reconcile(
	parent: Instance,
	currentNode: runtimeNode?,
	nextElement: elementModule.element?,
	options: reconcileOptions
): runtimeNode?
	return internals.reconcile(parent, currentNode, nextElement, options)
end

--————————————————————————————————————————————————————————————————————--

return module
