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

--- Binds a reactive value to a Roblox property in one direction.
--- @param source binding<T> Source binding.
--- @param instance Instance Target Roblox Instance.
--- @param propertyName string Roblox property name.
--- @return () -> () Cleanup callback.
function module.attach<T>(source: binding<T>, instance: Instance, propertyName: string): () -> ()
	local target = instance :: any
	local currentValue = source.get()

	if target[propertyName] ~= currentValue then
		target[propertyName] = currentValue
	end

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

--- Binds a reactive value to a Roblox Attribute with optional two-way synchronization.
--- @param source binding<T> Source binding.
--- @param instance Instance Target Roblox Instance.
--- @param attributeName string Attribute name.
--- @param twoWay boolean? Whether external Attribute changes should update the binding.
--- @return () -> () Cleanup callback.
function module.attachAttribute<T>(
	source: binding<T>,
	instance: Instance,
	attributeName: string,
	twoWay: boolean?
): () -> ()
	local currentValue = source.get()

	if instance:GetAttribute(attributeName) ~= currentValue then
		instance:SetAttribute(attributeName, currentValue :: any)
	end

	local sourceConnection = source.subscribe(function(change: bindingChange<T>)
		if instance:GetAttribute(attributeName) == change.current then
			return
		end

		instance:SetAttribute(attributeName, change.current :: any)
	end)

	local attributeConnection: RBXScriptConnection? = nil

	if twoWay == true then
		attributeConnection = instance:GetAttributeChangedSignal(attributeName):Connect(function()
			local value = instance:GetAttribute(attributeName)
			if value == nil then
				return
			end

			source.set(value :: T)
		end)
	end

	return function()
		sourceConnection.disconnect()

		if attributeConnection and attributeConnection.Connected then
			attributeConnection:Disconnect()
		end
	end
end

--————————————————————————————————————————————————————————————————————--

--- Binds a reactive value to a Roblox property with optional two-way synchronization.
--- @param source binding<T> Source binding.
--- @param instance Instance Target Roblox Instance.
--- @param propertyName string Roblox property name.
--- @param twoWay boolean? Whether external property changes should update the binding.
--- @return () -> () Cleanup callback.
function module.attachProperty<T>(source: binding<T>, instance: Instance, propertyName: string, twoWay: boolean?): () -> ()
	local target = instance :: any
	local currentValue = source.get()

	if target[propertyName] ~= currentValue then
		target[propertyName] = currentValue
	end

	local sourceConnection = source.subscribe(function(change: bindingChange<T>)
		if target[propertyName] == change.current then
			return
		end

		target[propertyName] = change.current
	end)

	local propertyConnection: RBXScriptConnection? = nil

	if twoWay == true then
		propertyConnection = instance:GetPropertyChangedSignal(propertyName):Connect(function()
			source.set(target[propertyName] :: T)
		end)
	end

	return function()
		sourceConnection.disconnect()

		if propertyConnection and propertyConnection.Connected then
			propertyConnection:Disconnect()
		end
	end
end

--————————————————————————————————————————————————————————————————————--

--- Creates a derived numeric binding clamped to a range.
--- @param source binding<number> Source numeric binding.
--- @param minimum number Minimum output value.
--- @param maximum number Maximum output value.
--- @return binding<number> Derived binding.
function module.clamp(source: binding<number>, minimum: number, maximum: number): binding<number>
	assert(minimum <= maximum, "Reactily binding minimum must not exceed maximum.")

	return module.map(source, function(value: number): number
		return math.clamp(value, minimum, maximum)
	end)
end

--————————————————————————————————————————————————————————————————————--

--- Combines two bindings into a derived binding.
--- @param first binding<A> First source binding.
--- @param second binding<B> Second source binding.
--- @param mapper (firstValue: A, secondValue: B) -> R Derivation callback.
--- @return binding<R> Derived binding.
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

--- Combines any number of bindings using an ordered value array.
--- @param sources {binding<any>} Source bindings.
--- @param mapper (values: {any}) -> R Derivation callback.
--- @return binding<R> Derived binding.
function module.combineMany<R>(sources: { binding<any> }, mapper: (values: { any }) -> R): binding<R>
	local function collect(): { any }
		local values: { any } = table.create(#sources)

		for index, source in sources do
			values[index] = source.get()
		end

		return values
	end

	local output = module.new(mapper(collect()))
	local connections: { signalModule.connection } = {}

	for _, source in sources do
		connections[#connections + 1] = source.subscribe(function()
			output.set(mapper(collect()))
		end)
	end

	local outputDelete = output.delete

	output.delete = function(): boolean
		for _, connection in connections do
			connection.disconnect()
		end

		table.clear(connections)

		return outputDelete()
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates a string binding by formatting values from another binding.
--- @param source binding<T> Source binding.
--- @param formatter (value: T) -> string Formatter callback.
--- @return binding<string> Derived formatted binding.
function module.format<T>(source: binding<T>, formatter: (value: T) -> string): binding<string>
	return module.map(source, formatter)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a binding derived from another binding.
--- @param source binding<A> Source binding.
--- @param mapper (value: A) -> B Derivation callback.
--- @return binding<B> Derived binding.
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

--- Creates a mutable typed reactive binding.
--- @param initialValue T Initial binding value.
--- @return binding<T> New reactive binding.
function module.new<T>(initialValue: T): binding<T>
	local changed: signalModule.signal<bindingChange<T>> = signalModule.new()

	local isDeleted = false
	local value = initialValue

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

--- Creates a numeric binding rounded to a fixed decimal precision.
--- @param source binding<number> Source numeric binding.
--- @param precision number Number of decimal places.
--- @return binding<number> Rounded derived binding.
function module.round(source: binding<number>, precision: number): binding<number>
	local multiplier = 10 ^ precision

	return module.map(source, function(value: number): number
		return math.round(value * multiplier) / multiplier
	end)
end

--————————————————————————————————————————————————————————————————————--

return module
