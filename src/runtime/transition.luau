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

--- Defers non-urgent work until after the current execution slice.
--- @param callback () -> () Work to execute as a low-priority transition.
--- @param onFinished (() -> ())? Optional completion callback.
--- @return thread Deferred transition thread.
function module.start(callback: () -> (), onFinished: (() -> ())?): thread
	return task.defer(function()
		local success, failure = pcall(function(): boolean
			callback()

			return true
		end)

		if onFinished then
			onFinished()
		end

		if success then
			return
		end

		error(failure, 0)
	end)
end

--————————————————————————————————————————————————————————————————————--

return module
