--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local batching = require(script.Parent.Parent.core.batching)
local elementModule = require(script.Parent.Parent.virtual.element)
local reconciler = require(script.Parent.Parent.virtual.reconciler)
local schedulerModule = require(script.Parent.Parent.core.scheduler)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local renderTaskKey = "render"

--————————————————————————————————————————————————————————————————————--

export type Root = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	flush: () -> (),
	getElement: () -> elementModule.Element?,
	getParent: () -> Instance,
	inspect: () -> reconciler.NodeSnapshot?,
	isDeleted: () -> boolean,
	isSuspended: () -> boolean,
	render: (elementValue: elementModule.Element?) -> (),
	resume: () -> boolean,
	suspend: () -> boolean,
}

type RootContext = {
	batchDepth: number,
	currentElement: elementModule.Element?,
	currentNode: reconciler.RuntimeNode?,
	isDeleted: boolean,
	isRendering: boolean,
	isSuspended: boolean,
	lastRenderReason: string,
	needsRender: boolean,
	parent: Instance,
	renderQueued: boolean,
	scheduler: schedulerModule.Scheduler,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily rendering root.
--- @param parent Instance Roblox parent that receives rendered hosts.
--- @return root New owned Reactily root.
function module.new(parent: Instance): Root
	assert(typeof(parent) == "Instance", "Reactily root parent must be an Instance.")

	local context: RootContext = {
		batchDepth = 0,
		currentElement = nil,
		currentNode = nil,
		isDeleted = false,
		isRendering = false,
		isSuspended = false,
		lastRenderReason = "initial render",
		needsRender = false,
		parent = parent,
		renderQueued = false,
		scheduler = schedulerModule.new(),
	}

	local onGlobalBatchFinished: () -> ()
	local renderNow: () -> ()
	local requestRender: (reason: string?) -> ()

	onGlobalBatchFinished = function()
		requestRender("global batch completed")
	end

	requestRender = function(reason: string?)
		if context.isDeleted then
			return
		end

		context.needsRender = true

		if reason then
			context.lastRenderReason = reason
		end

		if context.isSuspended then
			return
		end
		if context.batchDepth > 0 then
			return
		end

		if batching.isBatching() then
			batching.queue(onGlobalBatchFinished)
			return
		end

		context.renderQueued = true

		context.scheduler.enqueueKeyedPriority(renderTaskKey, schedulerModule.getCurrentPriority(), function()
			renderNow()
		end)
	end

	renderNow = function()
		if context.isDeleted then
			return
		end
		if context.isSuspended then
			return
		end

		if context.isRendering then
			requestRender("render requested while rendering")
			return
		end

		context.renderQueued = false
		context.needsRender = false
		context.isRendering = true

		local reason = context.lastRenderReason

		local success, failure = pcall(function(): boolean
			context.currentNode = reconciler.reconcile(context.parent, context.currentNode, context.currentElement, {
				renderReason = reason,
				requestRender = requestRender,
			})

			return true
		end)

		context.isRendering = false

		if not success then
			reconciler.delete(context.currentNode)
			context.currentNode = nil
			context.needsRender = true
			error(failure, 0)
		end

		if context.needsRender then
			requestRender(context.lastRenderReason)
		end
	end

	local function batch(callback: () -> ())
		assert(not context.isDeleted, "Reactily root is deleted.")

		context.batchDepth += 1

		local success, failure = pcall(function(): boolean
			callback()
			return true
		end)

		context.batchDepth -= 1

		if context.batchDepth == 0 and context.needsRender and not context.isSuspended then
			context.scheduler.cancelKey(renderTaskKey)
			context.renderQueued = false

			local priorityValue = schedulerModule.getCurrentPriority()
			if priorityValue >= schedulerModule.Priority.transition then
				requestRender(context.lastRenderReason)
			else
				renderNow()
			end
		end

		if success then
			return
		end

		error(failure, 0)
	end

	local function delete(): boolean
		if context.isDeleted then
			return false
		end

		context.isDeleted = true
		context.needsRender = false
		context.renderQueued = false

		context.scheduler.delete()
		reconciler.delete(context.currentNode)

		context.currentElement = nil
		context.currentNode = nil

		return true
	end

	local function flush()
		if context.isDeleted then
			return
		end

		context.scheduler.flush()
	end

	local function getElement(): elementModule.Element?
		return context.currentElement
	end

	local function getParent(): Instance
		return context.parent
	end

	local function inspect(): reconciler.NodeSnapshot?
		if context.isDeleted then
			return nil
		end

		return reconciler.inspect(context.currentNode)
	end

	local function getIsDeleted(): boolean
		return context.isDeleted
	end

	local function getIsSuspended(): boolean
		return context.isSuspended
	end

	local function render(elementValue: elementModule.Element?)
		assert(not context.isDeleted, "Reactily root is deleted.")

		if context.currentElement == elementValue and not context.needsRender then
			return
		end

		context.currentElement = elementValue
		context.needsRender = true
		context.lastRenderReason = "root element changed"

		if context.isSuspended then
			return
		end
		if context.batchDepth > 0 then
			return
		end

		if batching.isBatching() then
			batching.queue(onGlobalBatchFinished)
			return
		end

		context.scheduler.cancelKey(renderTaskKey)
		context.renderQueued = false

		local priorityValue = schedulerModule.getCurrentPriority()
		if priorityValue >= schedulerModule.Priority.transition then
			requestRender("root element changed")
			return
		end

		renderNow()
	end

	local function resume(): boolean
		if context.isDeleted then
			return false
		end
		if not context.isSuspended then
			return false
		end

		context.isSuspended = false

		if context.needsRender then
			renderNow()
		end

		return true
	end

	local function suspend(): boolean
		if context.isDeleted then
			return false
		end
		if context.isSuspended then
			return false
		end

		context.isSuspended = true
		context.scheduler.cancelKey(renderTaskKey)

		context.renderQueued = false

		return true
	end

	return {
		batch = batch,
		delete = delete,
		flush = flush,
		getElement = getElement,
		getParent = getParent,
		inspect = inspect,
		isDeleted = getIsDeleted,
		isSuspended = getIsSuspended,
		render = render,
		resume = resume,
		suspend = suspend,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Returns a snapshot of a mounted rendering root.
function module.inspectRoot(rootValue: Root): reconciler.NodeSnapshot?
    return rootValue.inspect()
end


-- Canonical public API names (discoverable directly from Luau).
module.createRoot = module.new

return module
