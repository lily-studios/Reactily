--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")
local signalModule = require(core:WaitForChild("signal"))

--————————————————————————————————————————————————————————————————————--

export type theme<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> signalModule.connection,
	update: (updater: (value: T) -> T) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

function module.new<T>(initialValue: T): theme<T>
	local changed: signalModule.signal<T> = signalModule.new()

	local isDeleted = false
	local value = initialValue

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true

		changed.delete()

		return true
	end

	local function get(): T
		assert(not isDeleted, "Reactily theme is deleted.")

		return value
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily theme is deleted.")

		if value == nextValue then return false end

		value = nextValue

		changed.fire(nextValue)

		return true
	end

	local function subscribe(callback: (value: T) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily theme is deleted.")

		return changed.connect(callback)
	end

	local function update(updater: (value: T) -> T): boolean
		assert(not isDeleted, "Reactily theme is deleted.")

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

function module.resolve<T, R>(themeValue: theme<T>, selector: (tokens: T) -> R): R
	return selector(themeValue.get())
end

--————————————————————————————————————————————————————————————————————--

return module
