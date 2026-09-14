--!strict

-- provides reactive bindings and derived binding helpers

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local core = script.Parent.Parent:WaitForChild("core")

local signalModule = require(core:WaitForChild("signal"))

--————————————————————————————————————————————————————————————————————--

export type bindingChange<T> = {
	current: T,
	previous: T,
}

export type binding<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (change: bindingChange<T>) -> ()) -> signalModule.connection,
}

--————————————————————————————————————————————————————————————————————--

--- Attaches a binding to an Instance property and keeps it synchronized.
--- @param source binding<T> Binding supplying property values.
--- @param instance Instance Instance containing the target property.
--- @param propertyName string Property name to update.
--- @return () -> () Cleanup function that disconnects the binding subscription.
function module.attach<T>(source: binding<T>, instance: Instance, propertyName: string): () -> ()
	local target = instance :: any

	target[propertyName] = source.get()

	local connection = source.subscribe(function(change: bindingChange<T>)
		if target[propertyName] == change.current then
			return
		end

		target[propertyName] = change.current
	end)

	return function()
		connection.disconnect()
	end
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived numeric binding clamped between a minimum and maximum.
--- @param source binding<number> Source numeric binding.
--- @param minimum number Minimum allowed value.
--- @param maximum number Maximum allowed value.
--- @return binding<number> Derived clamped binding.
function module.clamp(source: binding<number>, minimum: number, maximum: number): binding<number>
	assert(minimum <= maximum, "Reactily binding minimum must not exceed maximum.")

	return module.map(source, function(value: number): number
		return math.clamp(value, minimum, maximum)
	end)
end

--————————————————————————————————————————————————————————————————————--

--- Combines two bindings into one derived binding.
--- @param first binding<A> First source binding.
--- @param second binding<B> Second source binding.
--- @param mapper (firstValue: A, secondValue: B) -> R Function that derives the output value.
--- @return binding<R> Derived binding updated when either source changes.
function module.combine<A, B, R>(first: binding<A>, second: binding<B>, mapper: (firstValue: A, secondValue: B) -> R): binding<R>
	local output = module.new(mapper(first.get(), second.get()))

	local function update()
		output.set(mapper(first.get(), second.get()))
	end

	local firstConnection = first.subscribe(function()
		update()
	end)

	local secondConnection = second.subscribe(function()
		update()
	end)

	local outputDelete = output.delete

	output.delete = function(): boolean
		firstConnection.disconnect()
		secondConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived string binding using a formatter function.
--- @param source binding<T> Source binding.
--- @param formatter (value: T) -> string Function that converts each value to text.
--- @return binding<string> Derived formatted binding.
function module.format<T>(source: binding<T>, formatter: (value: T) -> string): binding<string>
	return module.map(source, formatter)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived binding that transforms values from a source binding.
--- @param source binding<A> Source binding.
--- @param mapper (value: A) -> B Function that converts source values.
--- @return binding<B> Derived mapped binding.
function module.map<A, B>(source: binding<A>, mapper: (value: A) -> B): binding<B>
	local output = module.new(mapper(source.get()))

	local sourceConnection = source.subscribe(function(change: bindingChange<A>)
		output.set(mapper(change.current))
	end)

	local outputDelete = output.delete

	output.delete = function(): boolean
		sourceConnection.disconnect()

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive binding with an initial value.
--- @param initialValue T Initial binding value.
--- @return binding<T> A new binding.
function module.new<T>(initialValue: T): binding<T>
	local changed: signalModule.signal<bindingChange<T>> = signalModule.new()

	local isDeleted = false
	local value = initialValue

	--- Deletes the binding and disconnects all subscribers.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		changed.delete()

		return true
	end

	local function get(): T
		assert(not isDeleted, "Reactily binding is deleted.")

		return value
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--- Replaces the current binding value.
	--- Subscribers are notified only when the value changes.
	--- @param nextValue T New binding value.
	--- @return boolean Whether the value changed.
	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily binding is deleted.")

		if value == nextValue then
			return false
		end

		local previous = value

		value = nextValue

		changed.fire({
			current = nextValue,
			previous = previous,
		})

		return true
	end

	--- Subscribes to future binding changes.
	--- @param callback (change: bindingChange<T>) -> () Callback receiving previous and current values.
	--- @return signalModule.connection Connection used to stop future notifications.
	local function subscribe(callback: (change: bindingChange<T>) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily binding is deleted.")

		return changed.connect(callback)
	end

	return {
		delete = delete,
		get = get,
		isDeleted = getIsDeleted,
		set = set,
		subscribe = subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived numeric binding rounded to the requested precision.
--- @param source binding<number> Source numeric binding.
--- @param precision number Number of decimal places to preserve.
--- @return binding<number> Derived rounded binding.
function module.round(source: binding<number>, precision: number): binding<number>
	local multiplier = 10 ^ precision

	return module.map(source, function(value: number): number
		return math.round(value * multiplier) / multiplier
	end)
end

--————————————————————————————————————————————————————————————————————--

return module
