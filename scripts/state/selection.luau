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

--- @reactilyType Selection<T>
export type selection<T> = {
	Clear: () -> boolean,
	Delete: () -> boolean,
	Deselect: (value: T) -> boolean,
	IsDeleted: () -> boolean,
	IsSelected: (value: T) -> boolean,
	Select: (value: T) -> boolean,
	SelectAll: (values: { T }) -> boolean,
	Subscribe: (callback: (values: { T }) -> ()) -> signalModule.connection,
	Toggle: (value: T) -> boolean,
	Values: () -> { T },
}

--————————————————————————————————————————————————————————————————————--

--- Creates a typed multi-selection controller.
--- @param initialValues {T}? Initial selected values.
--- @return selection<T> Owned selection controller.
function module.Create<T>(initialValues: { T }?): selection<T>
	local changed = signalModule.New()
	local isDeleted = false
	local order: { T } = {}
	local selected: { [any]: boolean } = {}

	local function snapshot(): { T }
		return table.clone(order)
	end

	local function emit()
		changed.Fire(snapshot())
	end

	local function selectValue(value: T): boolean
		assert(not isDeleted, "Reactily selection is deleted.")
		if selected[value] then
			return false
		end

		selected[value] = true
		order[#order + 1] = value
		emit()
		return true
	end

	local function deselect(value: T): boolean
		assert(not isDeleted, "Reactily selection is deleted.")
		if not selected[value] then
			return false
		end

		selected[value] = nil
		local index = table.find(order, value)
		if index then
			table.remove(order, index)
		end
		emit()
		return true
	end

	local function clear(): boolean
		assert(not isDeleted, "Reactily selection is deleted.")
		if #order == 0 then
			return false
		end

		table.clear(order)
		table.clear(selected)
		emit()
		return true
	end

	local function selectAll(values: { T }): boolean
		assert(not isDeleted, "Reactily selection is deleted.")
		local changedValue = false

		for _, value in values do
			if selected[value] then
				continue
			end
			selected[value] = true
			order[#order + 1] = value
			changedValue = true
		end

		if changedValue then
			emit()
		end

		return changedValue
	end

	if initialValues then
		for _, value in initialValues do
			if selected[value] then
				continue
			end
			selected[value] = true
			order[#order + 1] = value
		end
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		table.clear(order)
		table.clear(selected)
		changed.Delete()
		return true
	end

	return {
		Clear = clear,
		Delete = delete,
		Deselect = deselect,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		IsSelected = function(value: T): boolean
			return selected[value] == true
		end,
		Select = selectValue,
		SelectAll = selectAll,
		Subscribe = function(callback: (values: { T }) -> ()): signalModule.connection
			assert(not isDeleted, "Reactily selection is deleted.")
			return changed.Connect(callback)
		end,
		Toggle = function(value: T): boolean
			if selected[value] then
				return deselect(value)
			end
			return selectValue(value)
		end,
		Values = function(): { T }
			assert(not isDeleted, "Reactily selection is deleted.")
			return snapshot()
		end,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
