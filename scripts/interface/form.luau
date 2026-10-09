--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict


--————————————————————————————————————————————————————————————————————--

local bindingModule = require(script.Parent.Parent.runtime.binding)
local signalModule = require(script.Parent.Parent.core.signal)
local validatorModule = require(script.Parent.validator)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

type FormRecord = { [string]: any }

export type ValidationMap = {
	[string]: validatorModule.Validator<any>,
}

export type Form<T> = {
	delete: () -> boolean,
	field: (name: string) -> bindingModule.Binding<any>,
	get: () -> T,
	getErrors: () -> { [string]: string },
	isDeleted: () -> boolean,
	isDirty: () -> boolean,
	reset: (nextInitial: T?) -> (),
	set: (name: string, value: any) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> signalModule.Connection,
	validate: (validators: ValidationMap) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function cloneRecord(value: any): FormRecord
	return table.clone(value) :: any
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive form with per-field bindings, reset, dirty state, and validation.
--- @param initial T Initial form values.
--- @return form<T> Owned form controller.
function module.create<T>(initial: T): Form<T>
	assert(type(initial) == "table", "Reactily form initial value must be a table.")

	local changed = signalModule.new()
	local errors: { [string]: string } = {}
	local fields: { [string]: bindingModule.Binding<any> } = {}
	local fieldConnections: { [string]: signalModule.Connection } = {}

	local initialValues: FormRecord = cloneRecord(initial)
	local values: FormRecord = cloneRecord(initial)

	local isDeleted = false

	--——————————————————————————————————————————————————————————————————--

	local function cloneValue(): T
		return table.clone(values) :: any
	end

	--——————————————————————————————————————————————————————————————————--

	local function emitChanged()
		changed.fire(cloneValue())
	end

	--——————————————————————————————————————————————————————————————————--

	local function field(name: string): bindingModule.Binding<any>
		assert(not isDeleted, "Reactily form is deleted.")

		local existing = fields[name]

		if existing then
			return existing
		end

		local source = bindingModule.new(values[name])

		fields[name] = source

		fieldConnections[name] = source.subscribe(function(change)
			if isDeleted then
				return
			end

			if values[name] == change.current then
				return
			end

			values[name] = change.current
			errors[name] = nil

			emitChanged()
		end)

		return source
	end

	--——————————————————————————————————————————————————————————————————--

	local function set(name: string, value: any): boolean
		assert(not isDeleted, "Reactily form is deleted.")

		if values[name] == value then
			return false
		end

		values[name] = value
		errors[name] = nil

		local source = fields[name]

		if source then
			if source.get() ~= value then
				source.set(value)
			end
		end

		emitChanged()

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function reset(nextInitial: T?)
		assert(not isDeleted, "Reactily form is deleted.")

		if nextInitial ~= nil then
			assert(type(nextInitial) == "table", "Reactily form reset value must be a table.")

			initialValues = cloneRecord(nextInitial)
		end

		values = cloneRecord(initialValues)

		table.clear(errors)

		for name, source in fields do
			local nextValue = values[name]

			if source.get() == nextValue then
				continue
			end

			source.set(nextValue)
		end

		emitChanged()
	end

	--——————————————————————————————————————————————————————————————————--

	local function validate(validators: ValidationMap): boolean
		assert(not isDeleted, "Reactily form is deleted.")

		table.clear(errors)

		for name, validator in validators do
			local failure = validator(values[name])

			if failure == nil then
				continue
			end

			errors[name] = failure
		end

		return next(errors) == nil
	end

	--——————————————————————————————————————————————————————————————————--

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		for _, connection in fieldConnections do
			connection.disconnect()
		end

		for _, source in fields do
			source.delete()
		end

		table.clear(fieldConnections)
		table.clear(fields)
		table.clear(errors)

		changed.delete()

		return true
	end

	--——————————————————————————————————————————————————————————————————--

	local function get(): T
		assert(not isDeleted, "Reactily form is deleted.")

		return cloneValue()
	end

	--——————————————————————————————————————————————————————————————————--

	local function getErrors(): { [string]: string }
		assert(not isDeleted, "Reactily form is deleted.")

		return table.clone(errors)
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--——————————————————————————————————————————————————————————————————--

	local function getIsDirty(): boolean
		assert(not isDeleted, "Reactily form is deleted.")

		for name, value in values do
			if initialValues[name] == value then
				continue
			end

			return true
		end

		for name, value in initialValues do
			if values[name] == value then
				continue
			end

			return true
		end

		return false
	end

	--——————————————————————————————————————————————————————————————————--

	local function subscribe(callback: (value: T) -> ()): signalModule.Connection
		assert(not isDeleted, "Reactily form is deleted.")

		return changed.connect(callback)
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		delete = delete,
		field = field,
		get = get,
		getErrors = getErrors,
		isDeleted = getIsDeleted,
		isDirty = getIsDirty,
		reset = reset,
		set = set,
		subscribe = subscribe,
		validate = validate,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
