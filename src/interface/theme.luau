--!strict

-- provides reactive theme state and token resolution

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

--- Creates reactive theme state from an initial token value.
--- @param initialValue T Initial theme value or token table.
--- @return theme<T> A new theme object.
function module.new<T>(initialValue: T): theme<T>
	local changed: signalModule.signal<T> = signalModule.new()

	local isDeleted = false
	local value = initialValue

	--- Deletes the theme and disconnects all subscribers.
	--- @return boolean Whether deletion occurred.
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

	--- Replaces the current theme value.
	--- Subscribers are notified only when the value changes.
	--- @param nextValue T New theme value.
	--- @return boolean Whether the theme value changed.
	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily theme is deleted.")

		if value == nextValue then return false end

		value = nextValue

		changed.fire(nextValue)

		return true
	end

	--- Subscribes to future theme changes.
	--- @param callback (value: T) -> () Callback invoked with the new theme value.
	--- @return signalModule.connection Connection used to stop future notifications.
	local function subscribe(
		callback: (value: T) -> ()
	): signalModule.connection
		assert(not isDeleted, "Reactily theme is deleted.")

		return changed.connect(callback)
	end

	--- Updates the theme using its current value.
	--- @param updater (value: T) -> T Function that returns the next theme value.
	--- @return boolean Whether the resulting theme value changed.
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

--- Resolves a value from the current theme without creating a subscription.
--- @param themeValue theme<T> Theme containing the source tokens.
--- @param selector (tokens: T) -> R Function that selects or derives a value.
--- @return R The resolved value.
function module.resolve<T, R>(
	themeValue: theme<T>,
	selector: (tokens: T) -> R
): R
	return selector(themeValue.get())
end

--————————————————————————————————————————————————————————————————————--

return module