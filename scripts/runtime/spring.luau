--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local runService = game:GetService("RunService")

--————————————————————————————————————————————————————————————————————--

local signalModule = require(script.Parent.Parent.core.signal)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type springOptions = {
	damping: number?,
	epsilon: number?,
	frequency: number?,
}

export type spring<T> = {
	delete: () -> boolean,
	get: () -> T,
	getTarget: () -> T,
	isDeleted: () -> boolean,
	isSettled: () -> boolean,
	set: (value: T) -> boolean,
	setTarget: (value: T) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> signalModule.connection,
}

--————————————————————————————————————————————————————————————————————--

local function magnitude(value: any): number
	if type(value) == "number" then
		return math.abs(value)
	end

	if typeof(value) == "Vector2" or typeof(value) == "Vector3" then
		return value.Magnitude
	end

	if typeof(value) == "Color3" then
		return math.max(math.abs(value.R), math.abs(value.G), math.abs(value.B))
	end

	return math.huge
end

--————————————————————————————————————————————————————————————————————--

local function zeroLike(value: any): any
	if type(value) == "number" then
		return 0
	end

	if typeof(value) == "Vector2" then
		return Vector2.zero
	end

	if typeof(value) == "Vector3" then
		return Vector3.zero
	end

	if typeof(value) == "Color3" then
		return Color3.new()
	end

	error(`Reactily spring does not support value type {typeof(value)}.`, 2)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a spring for number, Vector2, Vector3, or Color3 values.
--- @param initialValue T Initial spring value.
--- @param options springOptions? Frequency, damping, and settle epsilon.
--- @return spring<T> New spring controller.
function module.new<T>(initialValue: T, options: springOptions?): spring<T>
	local settings: springOptions = options or {}

	local damping = 1
	local epsilon = 0.0001
	local frequency = 5

	if settings.damping ~= nil then
		damping = settings.damping
	end

	if settings.epsilon ~= nil then
		epsilon = settings.epsilon
	end

	if settings.frequency ~= nil then
		frequency = settings.frequency
	end

	damping = math.max(damping, 0)
	epsilon = math.max(epsilon, 0)
	frequency = math.max(frequency, 0.001)

	local angularFrequency = frequency * math.pi * 2
	local changed: signalModule.signal<T> = signalModule.new()

	local connection: RBXScriptConnection? = nil
	local isDeleted = false
	local target = initialValue
	local value = initialValue
	local velocity: any = zeroLike(initialValue)

	local function disconnectHeartbeat()
		local activeConnection = connection
		if not activeConnection then
			return
		end

		activeConnection:Disconnect()
		connection = nil
	end

	local function settled(): boolean
		local displacement = (target :: any) - (value :: any)

		if magnitude(displacement) > epsilon then
			return false
		end

		return magnitude(velocity) <= epsilon
	end

	local function update(deltaTime: number)
		if isDeleted then
			disconnectHeartbeat()
			return
		end

		local stepTime = math.min(math.max(deltaTime, 0), 1 / 15)

		local displacement = (target :: any) - (value :: any)

		local acceleration = displacement * (angularFrequency * angularFrequency)
			- velocity * (2 * damping * angularFrequency)

		velocity += acceleration * stepTime

		local nextValue = (value :: any) + velocity * stepTime

		if nextValue ~= value then
			value = nextValue
			changed.fire(value)
		end

		if not settled() then
			return
		end

		if value ~= target then
			value = target
			changed.fire(value)
		end

		velocity = zeroLike(value)

		disconnectHeartbeat()
	end

	local function ensureHeartbeat()
		if connection then
			return
		end
		if settled() then
			return
		end

		connection = runService.Heartbeat:Connect(update)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		disconnectHeartbeat()
		changed.delete()

		return true
	end

	local function get(): T
		assert(not isDeleted, "Reactily spring is deleted.")

		return value
	end

	local function getTarget(): T
		assert(not isDeleted, "Reactily spring is deleted.")

		return target
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function getIsSettled(): boolean
		return settled()
	end

	local function set(nextValue: T): boolean
		assert(not isDeleted, "Reactily spring is deleted.")

		if value == nextValue and target == nextValue then
			return false
		end

		value = nextValue
		target = nextValue
		velocity = zeroLike(nextValue)

		disconnectHeartbeat()
		changed.fire(nextValue)

		return true
	end

	local function setTarget(nextTarget: T): boolean
		assert(not isDeleted, "Reactily spring is deleted.")

		if target == nextTarget then
			return false
		end

		target = nextTarget

		ensureHeartbeat()

		return true
	end

	local function subscribe(callback: (value: T) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily spring is deleted.")

		return changed.connect(callback)
	end

	return {
		delete = delete,
		get = get,
		getTarget = getTarget,
		isDeleted = getIsDeleted,
		isSettled = getIsSettled,
		set = set,
		setTarget = setTarget,
		subscribe = subscribe,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
