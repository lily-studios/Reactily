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

type formRecord = { [string]: any }

--- @reactilyType ValidationMap
export type validationMap = {
	[string]: validatorModule.validator<any>,
}

--- @reactilyType Form<T>
export type form<T> = {
	Delete: () -> boolean,
	Field: (name: string) -> bindingModule.binding<any>,
	Get: () -> T,
	GetErrors: () -> { [string]: string },
	IsDeleted: () -> boolean,
	IsDirty: () -> boolean,
	Reset: (nextInitial: T?) -> (),
	Set: (name: string, value: any) -> boolean,
	Subscribe: (callback: (value: T) -> ()) -> signalModule.connection,
	Validate: (validators: validationMap) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function cloneRecord(value: any): formRecord
	return table.clone(value) :: any
end

--————————————————————————————————————————————————————————————————————--

--- Creates a reactive form with per-field bindings, reset, dirty state, and validation.
--- @param initial T Initial form values.
--- @return form<T> Owned form controller.
function module.Create<T>(initial: T): form<T>
	assert(type(initial) == "table", "Reactily form initial value must be a table.")

	local changed = signalModule.New()
	local errors: { [string]: string } = {}
	local fields: { [string]: bindingModule.binding<any> } = {}
	local fieldConnections: { [string]: signalModule.connection } = {}

	local initialValues: formRecord = cloneRecord(initial)
	local values: formRecord = cloneRecord(initial)

	local isDeleted = false

	--——————————————————————————————————————————————————————————————————--

	local function cloneValue(): T
		return table.clone(values) :: any
	end

	--——————————————————————————————————————————————————————————————————--

	local function emitChanged()
		changed.Fire(cloneValue())
	end

	--——————————————————————————————————————————————————————————————————--

	local function field(name: string): bindingModule.binding<any>
		assert(not isDeleted, "Reactily form is deleted.")

		local existing = fields[name]

		if existing then
			return existing
		end

		local source = bindingModule.New(values[name])

		fields[name] = source

		fieldConnections[name] = source.Subscribe(function(change)
			if isDeleted then
				return
			end

			if values[name] == change.Current then
				return
			end

			values[name] = change.Current
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
			if source.Get() ~= value then
				source.Set(value)
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

			if source.Get() == nextValue then
				continue
			end

			source.Set(nextValue)
		end

		emitChanged()
	end

	--——————————————————————————————————————————————————————————————————--

	local function validate(validators: validationMap): boolean
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
			connection.Disconnect()
		end

		for _, source in fields do
			source.Delete()
		end

		table.clear(fieldConnections)
		table.clear(fields)
		table.clear(errors)

		changed.Delete()

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

	local function subscribe(callback: (value: T) -> ()): signalModule.connection
		assert(not isDeleted, "Reactily form is deleted.")

		return changed.Connect(callback)
	end

	--——————————————————————————————————————————————————————————————————--

	return {
		Delete = delete,
		Field = field,
		Get = get,
		GetErrors = getErrors,
		IsDeleted = getIsDeleted,
		IsDirty = getIsDirty,
		Reset = reset,
		Set = set,
		Subscribe = subscribe,
		Validate = validate,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
