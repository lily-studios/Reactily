--!strict

-- provides typed reactive values without requiring component rerenders

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

function module.attach<T>(source: binding<T>, instance: Instance, propertyName: string): () -> ()
	local target = instance :: any
	target[propertyName] = source.get()

	local connection = source.subscribe(function(change: bindingChange<T>)
		if target[propertyName] == change.current then return end

		target[propertyName] = change.current
	end)

	return function()
		connection.disconnect()
	end
end

--————————————————————————————————————————————————————————————————————--

function module.clamp(source: binding<number>, minimum: number, maximum: number): binding<number>
	assert(minimum <= maximum, "Reactily binding minimum must not exceed maximum.")

	return module.map(source, function(value: number): number
		return math.clamp(value, minimum, maximum)
	end)
end

--————————————————————————————————————————————————————————————————————--

function module.combine<A, B, R>(
	first: binding<A>,
	second: binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): binding<R>
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

function module.format<T>(source: binding<T>, formatter: (value: T) -> string): binding<string>
	return module.map(source, formatter)
end

--————————————————————————————————————————————————————————————————————--

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

function module.new<T>(initialValue: T): binding<T>
	local changed = signalModule.new<bindingChange<T>>()
	local isDeleted = false
	local value = initialValue

	local function delete(): boolean
		if isDeleted then return false end

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

	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily binding is deleted.")
		if value == nextValue then return false end

		local previous = value
		value = nextValue

		changed.fire({
			current = nextValue,
			previous = previous,
		})

		return true
	end

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

function module.round(source: binding<number>, precision: number): binding<number>
	local multiplier = 10 ^ precision

	return module.map(source, function(value: number): number
		return math.round(value * multiplier) / multiplier
	end)
end

--————————————————————————————————————————————————————————————————————--

return module
