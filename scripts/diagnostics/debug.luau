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
	local kind = tostring(node.Kind or "unknown")
	local name = tostring(node.ClassName or node.Key or kind)
	lines[#lines + 1] = `{prefix}{name} [{kind}]`

	local children = node.Children
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
function module.FormatTree(snapshot: any): string
	local lines: { string } = {}
	appendTree(lines, snapshot, 0)
	return table.concat(lines, "\n")
end

--————————————————————————————————————————————————————————————————————--

--- Returns profiler information and a formatted runtime tree for a root.
--- @param rootValue any Reactily root.
--- @return any Debug snapshot.
function module.Inspect(rootValue: any): any
	local snapshot = rootValue.Inspect()

	return {
		Profiler = profilerModule.Snapshot(),
		Tree = snapshot,
		TreeText = module.FormatTree(snapshot),
	}
end

--————————————————————————————————————————————————————————————————————--

return module
