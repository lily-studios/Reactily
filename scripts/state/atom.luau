--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type atomChange<T> = {
	Current: T,
	Previous: T,
}

export type atom<T> = {
	Delete: () -> boolean,
	Get: () -> T,
	IsDeleted: () -> boolean,
	Set: (value: T) -> boolean,
	Subscribe: (callback: (change: atomChange<T>) -> ()) -> signalModule.connection,
	Update: (updater: (previous: T) -> T) -> boolean,
}

export type computed<T> = {
	Delete: () -> boolean,
	Get: () -> T,
	IsDeleted: () -> boolean,
	Subscribe: (callback: (change: atomChange<T>) -> ()) -> signalModule.connection,
}

export type historyAtom<T> = atom<T> & {
	CanRedo: () -> boolean,
	CanUndo: () -> boolean,
	ClearHistory: () -> (),
	GetFutureCount: () -> number,
	GetPastCount: () -> number,
	Redo: () -> boolean,
	Undo: () -> boolean,
}

type historyEntry<T> = {
	Value: T,
}

--————————————————————————————————————————————————————————————————————--

--- Creates a computed atom derived from another atom.
--- @param source atom<A> Source atom.
--- @param selector (value: A) -> B Derivation callback.
--- @return computed<B> Derived read-only atom.
function module.Computed<A, B>(source: atom<A>, selector: (value: A) -> B): computed<B>
	local output = module.New(selector(source.Get()))

	local sourceConnection = source.Subscribe(function(change: atomChange<A>)
		output.Set(selector(change.Current))
	end)

	local outputDelete = output.Delete

	output.Delete = function(): boolean
		sourceConnection.Disconnect()

		return outputDelete()
	end

	return {
		Delete = output.Delete,
		Get = output.Get,
		IsDeleted = output.IsDeleted,
		Subscribe = output.Subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates an atom synchronized with a Roblox Attribute.
--- @param instance Instance Instance that owns the Attribute.
--- @param attributeName string Attribute name.
--- @param defaultValue T Value used when the Attribute is missing.
--- @return atom<T> Attribute-backed atom.
function module.FromAttribute<T>(instance: Instance, attributeName: string, defaultValue: T): atom<T>
	local currentAttribute = instance:GetAttribute(attributeName)
	local initialValue = defaultValue

	if currentAttribute ~= nil then
		initialValue = currentAttribute :: T
	end

	local output = module.New(initialValue)

	local isApplyingAttribute = false
	local isApplyingState = false

	local attributeConnection = instance:GetAttributeChangedSignal(attributeName):Connect(function()
		if isApplyingState then
			return
		end

		local nextValue = instance:GetAttribute(attributeName)

		isApplyingAttribute = true
		if nextValue == nil then
			output.Set(defaultValue)
		else
			output.Set(nextValue :: T)
		end
		isApplyingAttribute = false
	end)

	local stateConnection = output.Subscribe(function(change: atomChange<T>)
		if isApplyingAttribute then
			return
		end
		if instance:GetAttribute(attributeName) == change.Current then
			return
		end

		isApplyingState = true
		instance:SetAttribute(attributeName, change.Current :: any)
		isApplyingState = false
	end)

	local outputDelete = output.Delete

	output.Delete = function(): boolean
		attributeConnection:Disconnect()
		stateConnection.Disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates an atom with bounded undo and redo history.
--- @param initialValue T Initial atom value.
--- @param limit number Maximum retained undo entries.
--- @return historyAtom<T> Historical atom.
function module.History<T>(initialValue: T, limit: number): historyAtom<T>
	assert(limit > 0, "Reactily history limit must be greater than zero.")

	local base = module.New(initialValue)

	local future: { historyEntry<T> } = {}
	local isRecording = true
	local past: { historyEntry<T> } = {}

	local baseSet = base.Set

	local function canRedo(): boolean
		return #future > 0
	end

	local function canUndo(): boolean
		return #past > 0
	end

	local function clearHistory()
		if #future == 0 and #past == 0 then
			return
		end

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
			Value = previous,
		}

		if #past <= limit then
			return
		end

		table.remove(past, 1)
	end

	local function set(nextValue: T): boolean
		local previous = base.Get()
		local didChange = baseSet(nextValue)

		if not didChange then
			return false
		end
		if not isRecording then
			return true
		end

		record(previous)

		if #future > 0 then
			table.clear(future)
		end

		return true
	end

	local function redo(): boolean
		local entry = future[#future]
		if not entry then
			return false
		end

		future[#future] = nil

		past[#past + 1] = {
			Value = base.Get(),
		}

		isRecording = false
		baseSet(entry.Value)
		isRecording = true

		return true
	end

	local function undo(): boolean
		local entry = past[#past]
		if not entry then
			return false
		end

		past[#past] = nil

		future[#future + 1] = {
			Value = base.Get(),
		}

		isRecording = false
		baseSet(entry.Value)
		isRecording = true

		return true
	end

	local function update(updater: (previous: T) -> T): boolean
		return set(updater(base.Get()))
	end

	return {
		CanRedo = canRedo,
		CanUndo = canUndo,
		ClearHistory = clearHistory,
		Delete = base.Delete,
		Get = base.Get,
		GetFutureCount = getFutureCount,
		GetPastCount = getPastCount,
		IsDeleted = base.IsDeleted,
		Redo = redo,
		Set = set,
		Subscribe = base.Subscribe,
		Undo = undo,
		Update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a standalone typed reactive atom.
--- @param initialValue T Initial atom value.
--- @return atom<T> New atom.
function module.New<T>(initialValue: T): atom<T>
	local changed: signalModule.signal<atomChange<T>> = signalModule.New()

	local isDeleted = false
	local value = initialValue

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		changed.Delete()

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
		if value == nextValue then
			return false
		end

		local previous = value
		value = nextValue

		changed.Fire({
			Current = nextValue,
			Previous = previous,
		})

		return true
	end

	local function subscribe(callback: (change: atomChange<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily atom is deleted.")

		return changed.Connect(callback)
	end

	local function update(updater: (previous: T) -> T): boolean
		assert(not isDeleted, "Reactily atom is deleted.")

		return set(updater(value))
	end

	return {
		Delete = delete,
		Get = get,
		IsDeleted = getIsDeleted,
		Set = set,
		Subscribe = subscribe,
		Update = update,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
