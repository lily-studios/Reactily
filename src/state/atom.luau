--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")
local signalModule = require(core:WaitForChild("signal"))

--————————————————————————————————————————————————————————————————————--

export type atomChange<T> = {
	current: T,
	previous: T,
}

export type atom<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (change: atomChange<T>) -> ()) -> signalModule.connection,
	update: (updater: (previous: T) -> T) -> boolean,
}

export type computed<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: atomChange<T>) -> ()) -> signalModule.connection,
}

export type historyAtom<T> = atom<T> & {
	canRedo: () -> boolean,
	canUndo: () -> boolean,
	clearHistory: () -> (),
	getFutureCount: () -> number,
	getPastCount: () -> number,
	redo: () -> boolean,
	undo: () -> boolean,
}

type historyEntry<T> = {
	value: T,
}

--————————————————————————————————————————————————————————————————————--

function module.computed<A, B>(source: atom<A>, selector: (value: A) -> B): computed<B>
	local output = module.new(selector(source.get()))
	local sourceConnection = source.subscribe(function(change: atomChange<A>)
		output.set(selector(change.current))
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return {
		delete = output.delete,
		get = output.get,
		isDeleted = output.isDeleted,
		subscribe = output.subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.fromAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): atom<T>
	local currentAttribute = instance:GetAttribute(attributeName)
	local initialValue = defaultValue

	if currentAttribute ~= nil then
		initialValue = currentAttribute :: T
	end

	local output = module.new(initialValue)
	local isApplyingAttribute = false
	local isApplyingState = false
	local attributeConnection = instance:GetAttributeChangedSignal(attributeName):Connect(function()
		if isApplyingState then return end

		local nextValue = instance:GetAttribute(attributeName)
		if nextValue == nil then return end

		isApplyingAttribute = true
		output.set(nextValue :: T)
		isApplyingAttribute = false
	end)
	local stateConnection = output.subscribe(function(change: atomChange<T>)
		if isApplyingAttribute then return end
		if instance:GetAttribute(attributeName) == change.current then return end

		isApplyingState = true
		instance:SetAttribute(attributeName, change.current)
		isApplyingState = false
	end)
	local outputDelete = output.delete

	output.delete = function(): boolean
		attributeConnection:Disconnect()
		stateConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

function module.history<T>(initialValue: T, limit: number): historyAtom<T>
	assert(limit > 0, "Reactily history limit must be greater than zero.")

	local base = module.new(initialValue)
	local future: {historyEntry<T>} = {}
	local isRecording = true
	local past: {historyEntry<T>} = {}
	local baseSet = base.set

	local function canRedo(): boolean
		return #future > 0
	end

	local function canUndo(): boolean
		return #past > 0
	end

	local function clearHistory()
		table.clear(future)
		table.clear(past)
	end

	local function getFutureCount(): number
		return #future
	end

	local function getPastCount(): number
		return #past
	end

	local function record(previous: T)
		past[#past + 1] = {
			value = previous,
		}

		if #past <= limit then return end

		table.remove(past, 1)
	end

	local function set(value: T): boolean
		local previous = base.get()
		local didChange = baseSet(value)

		if not didChange then return false end
		if not isRecording then return true end

		record(previous)
		table.clear(future)

		return true
	end

	local function redo(): boolean
		local entry = future[#future]
		if not entry then return false end

		future[#future] = nil
		past[#past + 1] = {
			value = base.get(),
		}

		isRecording = false
		baseSet(entry.value)
		isRecording = true

		return true
	end

	local function undo(): boolean
		local entry = past[#past]
		if not entry then return false end

		past[#past] = nil
		future[#future + 1] = {
			value = base.get(),
		}

		isRecording = false
		baseSet(entry.value)
		isRecording = true

		return true
	end

	local function update(updater: (previous: T) -> T): boolean
		return set(updater(base.get()))
	end

	return {
		canRedo = canRedo,
		canUndo = canUndo,
		clearHistory = clearHistory,
		delete = base.delete,
		get = base.get,
		getFutureCount = getFutureCount,
		getPastCount = getPastCount,
		isDeleted = base.isDeleted,
		redo = redo,
		set = set,
		subscribe = base.subscribe,
		undo = undo,
		update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

function module.new<T>(initialValue: T): atom<T>
	local changed: signalModule.signal<atomChange<T>> = signalModule.new()

	local isDeleted = false
	local value = initialValue

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true

		changed.delete()

		return true
	end

	local function get(): T
		assert(not isDeleted, "Reactily atom is deleted.")

		return value
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily atom is deleted.")

		if value == nextValue then return false end

		local previous = value

		value = nextValue

		changed.fire({
			current = nextValue,
			previous = previous,
		})

		return true
	end

	local function subscribe(callback: (change: atomChange<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily atom is deleted.")

		return changed.connect(callback)
	end

	local function update(updater: (previous: T) -> T): boolean
		assert(not isDeleted, "Reactily atom is deleted.")

		return set(updater(value))
	end

	return {
		delete = delete,
		get = get,
		isDeleted = getIsDeleted,
		set = set,
		subscribe = subscribe,
		update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
