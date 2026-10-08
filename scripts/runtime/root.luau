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

export type root = {
	Batch: (callback: () -> ()) -> (),
	Delete: () -> boolean,
	Flush: () -> (),
	GetElement: () -> elementModule.element?,
	GetParent: () -> Instance,
	Inspect: () -> reconciler.nodeSnapshot?,
	IsDeleted: () -> boolean,
	IsSuspended: () -> boolean,
	render: (elementValue: elementModule.element?) -> (),
	Resume: () -> boolean,
	Suspend: () -> boolean,
}

type rootContext = {
	BatchDepth: number,
	CurrentElement: elementModule.element?,
	CurrentNode: reconciler.runtimeNode?,
	IsDeleted: boolean,
	IsRendering: boolean,
	IsSuspended: boolean,
	LastRenderReason: string,
	NeedsRender: boolean,
	Parent: Instance,
	RenderQueued: boolean,
	scheduler: schedulerModule.scheduler,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily rendering root.
--- @param parent Instance Roblox parent that receives rendered hosts.
--- @return root New owned Reactily root.
function module.New(parent: Instance): root
	assert(typeof(parent) == "Instance", "Reactily root parent must be an Instance.")

	local context: rootContext = {
		BatchDepth = 0,
		CurrentElement = nil,
		CurrentNode = nil,
		IsDeleted = false,
		IsRendering = false,
		IsSuspended = false,
		LastRenderReason = "initial render",
		NeedsRender = false,
		Parent = parent,
		RenderQueued = false,
		scheduler = schedulerModule.New(),
	}

	local onGlobalBatchFinished: () -> ()
	local renderNow: () -> ()
	local requestRender: (reason: string?) -> ()

	onGlobalBatchFinished = function()
		requestRender("global batch completed")
	end

	requestRender = function(reason: string?)
		if context.IsDeleted then
			return
		end

		context.NeedsRender = true

		if reason then
			context.LastRenderReason = reason
		end

		if context.IsSuspended then
			return
		end
		if context.BatchDepth > 0 then
			return
		end

		if batching.IsBatching() then
			batching.Queue(onGlobalBatchFinished)
			return
		end

		context.RenderQueued = true

		context.scheduler.EnqueueKeyedPriority(renderTaskKey, schedulerModule.GetCurrentPriority(), function()
			renderNow()
		end)
	end

	renderNow = function()
		if context.IsDeleted then
			return
		end
		if context.IsSuspended then
			return
		end

		if context.IsRendering then
			requestRender("render requested while rendering")
			return
		end

		context.RenderQueued = false
		context.NeedsRender = false
		context.IsRendering = true

		local reason = context.LastRenderReason

		local success, failure = pcall(function(): boolean
			context.CurrentNode = reconciler.Reconcile(context.Parent, context.CurrentNode, context.CurrentElement, {
				RenderReason = reason,
				RequestRender = requestRender,
			})

			return true
		end)

		context.IsRendering = false

		if not success then
			reconciler.Delete(context.CurrentNode)
			context.CurrentNode = nil
			context.NeedsRender = true
			error(failure, 0)
		end

		if context.NeedsRender then
			requestRender(context.LastRenderReason)
		end
	end

	local function batch(callback: () -> ())
		assert(not context.IsDeleted, "Reactily root is deleted.")

		context.BatchDepth += 1

		local success, failure = pcall(function(): boolean
			callback()
			return true
		end)

		context.BatchDepth -= 1

		if context.BatchDepth == 0 and context.NeedsRender and not context.IsSuspended then
			context.scheduler.CancelKey(renderTaskKey)
			context.RenderQueued = false

			local priorityValue = schedulerModule.GetCurrentPriority()
			if priorityValue >= schedulerModule.Priority.Transition then
				requestRender(context.LastRenderReason)
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
		if context.IsDeleted then
			return false
		end

		context.IsDeleted = true
		context.NeedsRender = false
		context.RenderQueued = false

		context.scheduler.Delete()
		reconciler.Delete(context.CurrentNode)

		context.CurrentElement = nil
		context.CurrentNode = nil

		return true
	end

	local function flush()
		if context.IsDeleted then
			return
		end

		context.scheduler.Flush()
	end

	local function getElement(): elementModule.element?
		return context.CurrentElement
	end

	local function getParent(): Instance
		return context.Parent
	end

	local function inspect(): reconciler.nodeSnapshot?
		if context.IsDeleted then
			return nil
		end

		return reconciler.Inspect(context.CurrentNode)
	end

	local function getIsDeleted(): boolean
		return context.IsDeleted
	end

	local function getIsSuspended(): boolean
		return context.IsSuspended
	end

	local function render(elementValue: elementModule.element?)
		assert(not context.IsDeleted, "Reactily root is deleted.")

		if context.CurrentElement == elementValue and not context.NeedsRender then
			return
		end

		context.CurrentElement = elementValue
		context.NeedsRender = true
		context.LastRenderReason = "root element changed"

		if context.IsSuspended then
			return
		end
		if context.BatchDepth > 0 then
			return
		end

		if batching.IsBatching() then
			batching.Queue(onGlobalBatchFinished)
			return
		end

		context.scheduler.CancelKey(renderTaskKey)
		context.RenderQueued = false

		local priorityValue = schedulerModule.GetCurrentPriority()
		if priorityValue >= schedulerModule.Priority.Transition then
			requestRender("root element changed")
			return
		end

		renderNow()
	end

	local function resume(): boolean
		if context.IsDeleted then
			return false
		end
		if not context.IsSuspended then
			return false
		end

		context.IsSuspended = false

		if context.NeedsRender then
			renderNow()
		end

		return true
	end

	local function suspend(): boolean
		if context.IsDeleted then
			return false
		end
		if context.IsSuspended then
			return false
		end

		context.IsSuspended = true
		context.scheduler.CancelKey(renderTaskKey)

		context.RenderQueued = false

		return true
	end

	return {
		Batch = batch,
		Delete = delete,
		Flush = flush,
		GetElement = getElement,
		GetParent = getParent,
		Inspect = inspect,
		IsDeleted = getIsDeleted,
		IsSuspended = getIsSuspended,
		render = render,
		Resume = resume,
		Suspend = suspend,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
