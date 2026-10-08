--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local profilerModule = require(script.Parent.profiler)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local function appendTree(lines: { string }, node: any, depth: number)
	if node == nil then
		return
	end

	local prefix = string.rep("  ", depth)
	local kind = tostring(node.kind or "unknown")
	local name = tostring(node.className or node.key or kind)
	lines[#lines + 1] = `{prefix}{name} [{kind}]`

	local children = node.children
	if type(children) ~= "table" then
		return
	end

	for _, child in children do
		appendTree(lines, child, depth + 1)
	end
end

--————————————————————————————————————————————————————————————————————--

--- Formats a root inspection snapshot as a readable tree.
--- @param snapshot any Value returned by root.inspect().
--- @return string Formatted tree.
function module.formatTree(snapshot: any): string
	local lines: { string } = {}
	appendTree(lines, snapshot, 0)
	return table.concat(lines, "\n")
end

--————————————————————————————————————————————————————————————————————--

--- Returns profiler information and a formatted runtime tree for a root.
--- @param rootValue any Reactily root.
--- @return any Debug snapshot.
function module.inspect(rootValue: any): any
	local snapshot = rootValue.inspect()

	return {
		Profiler = profilerModule.snapshot(),
		Tree = snapshot,
		TreeText = module.formatTree(snapshot),
	}
end

--————————————————————————————————————————————————————————————————————--

return module
