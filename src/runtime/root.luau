--!strict

-- provides Reactily root rendering, batching, suspension, and lifecycle control

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")
local virtual = script.Parent.Parent:WaitForChild("virtual")

local elementModule = require(virtual:WaitForChild("element"))
local reconciler = require(virtual:WaitForChild("reconciler"))
local schedulerModule = require(core:WaitForChild("scheduler"))

--————————————————————————————————————————————————————————————————————--

local renderTaskKey = "render"

--————————————————————————————————————————————————————————————————————--

export type root = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	flush: () -> (),
	getElement: () -> elementModule.element?,
	getParent: () -> Instance,
	isDeleted: () -> boolean,
	isSuspended: () -> boolean,
	render: (elementValue: elementModule.element?) -> (),
	resume: () -> boolean,
	suspend: () -> boolean,
}

type rootContext = {
	batchDepth: number,
	currentElement: elementModule.element?,
	currentNode: reconciler.runtimeNode?,
	isDeleted: boolean,
	isRendering: boolean,
	isSuspended: boolean,
	needsRender: boolean,
	parent: Instance,
	renderQueued: boolean,
	scheduler: schedulerModule.scheduler,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a Reactily rendering root under the supplied parent.
--- @param parent Instance Roblox Instance that receives rendered hosts.
--- @return root A new rendering root.
function module.new(parent: Instance): root
	assert(typeof(parent) == "Instance", "Reactily root parent must be an Instance.")

	local context: rootContext = {
		batchDepth = 0,
		currentElement = nil,
		currentNode = nil,
		isDeleted = false,
		isRendering = false,
		isSuspended = false,
		needsRender = false,
		parent = parent,
		renderQueued = false,
		scheduler = schedulerModule.new(),
	}

	local renderNow: () -> ()
	local requestRender: () -> ()

	requestRender = function()
		if context.isDeleted then return end

		context.needsRender = true

		if context.isSuspended then return end
		if context.batchDepth > 0 then return end
		if context.renderQueued then return end

		context.renderQueued = true

		context.scheduler.enqueueKeyed(renderTaskKey, function()
			renderNow()
		end)
	end

	renderNow = function()
		if context.isDeleted then return end
		if context.isSuspended then return end

		if context.isRendering then
			requestRender()

			return
		end

		context.renderQueued = false
		context.needsRender = false
		context.isRendering = true

		local success, failure = pcall(function()
			context.currentNode = reconciler.reconcile(
				context.parent,
				context.currentNode,
				context.currentElement,
				{
					requestRender = requestRender,
				}
			)
		end)

		context.isRendering = false

		if not success then
			error(failure)
		end

		if context.needsRender then
			requestRender()
		end
	end

	--- Groups root updates and performs pending rendering after the outermost batch completes.
	--- @param callback () -> () Callback containing the updates to batch.
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

			renderNow()
		end

		if success then return end

		error(failure)
	end

	--- Deletes the root, scheduler, and currently mounted runtime tree.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if context.isDeleted then return false end

		context.isDeleted = true
		context.needsRender = false
		context.renderQueued = false

		context.scheduler.delete()
		reconciler.delete(context.currentNode)

		context.currentElement = nil
		context.currentNode = nil

		return true
	end

	--- Immediately flushes work currently queued by the root scheduler.
	local function flush()
		if context.isDeleted then return end

		context.scheduler.flush()
	end

	local function getElement(): elementModule.element?
		return context.currentElement
	end

	local function getParent(): Instance
		return context.parent
	end

	local function getIsDeleted(): boolean
		return context.isDeleted
	end

	local function getIsSuspended(): boolean
		return context.isSuspended
	end

	--- Renders an element into the root or unmounts the current tree when nil is supplied.
	--- Unchanged element references are skipped when no render is pending.
	--- @param elementValue elementModule.element? Element to render, or nil to unmount.
	local function render(elementValue: elementModule.element?)
		assert(not context.isDeleted, "Reactily root is deleted.")

		if context.currentElement == elementValue and not context.needsRender then return end

		context.currentElement = elementValue
		context.needsRender = true

		if context.isSuspended then return end
		if context.batchDepth > 0 then return end

		context.scheduler.cancelKey(renderTaskKey)
		context.renderQueued = false

		renderNow()
	end

	--- Resumes rendering after the root has been suspended.
	--- Pending render work is applied immediately when needed.
	--- @return boolean Whether the root transitioned from suspended to active.
	local function resume(): boolean
		if context.isDeleted then return false end
		if not context.isSuspended then return false end

		context.isSuspended = false

		if context.needsRender then
			renderNow()
		end

		return true
	end

	--- Suspends rendering while preserving the current mounted tree and pending element state.
	--- @return boolean Whether the root transitioned into the suspended state.
	local function suspend(): boolean
		if context.isDeleted then return false end
		if context.isSuspended then return false end

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
		isDeleted = getIsDeleted,
		isSuspended = getIsSuspended,
		render = render,
		resume = resume,
		suspend = suspend,
	}
end

--————————————————————————————————————————————————————————————————————--

return module