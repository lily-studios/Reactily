--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local guiService = game:GetService("GuiService")

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type focusGroup = {
	add: (object: GuiObject) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	focusFirst: () -> boolean,
	focusLast: () -> boolean,
	focusNext: () -> boolean,
	focusPrevious: () -> boolean,
	getCurrent: () -> GuiObject?,
	getItems: () -> { GuiObject },
	isDeleted: () -> boolean,
	remove: (object: GuiObject) -> boolean,
	setWrapAround: (enabled: boolean) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function canFocus(object: GuiObject): boolean
	if not object.Parent then
		return false
	end
	if not object.Visible then
		return false
	end
	if not object.Selectable then
		return false
	end

	return true
end

--————————————————————————————————————————————————————————————————————--

--- Clears the current Roblox GUI selection.
function module.clearSelection()
	guiService.SelectedObject = nil
end

--————————————————————————————————————————————————————————————————————--

--- Creates a focus group with forward/backward navigation.
--- @return focusGroup New focus group.
function module.new(): focusGroup
	local isDeleted = false
	local items: { GuiObject } = {}
	local wrapAround = true

	local function add(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")
		if table.find(items, object) then
			return false
		end

		items[#items + 1] = object
		return true
	end

	local function clear()
		assert(not isDeleted, "Reactily focus group is deleted.")
		table.clear(items)
	end

	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true
		table.clear(items)
		return true
	end

	local function focusFirst(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for _, object in items do
			if not canFocus(object) then
				continue
			end

			guiService.SelectedObject = object
			return true
		end

		return false
	end

	local function focusLast(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for index = #items, 1, -1 do
			local object = items[index]
			if not canFocus(object) then
				continue
			end

			guiService.SelectedObject = object
			return true
		end

		return false
	end

	local function getCurrent(): GuiObject?
		local selected = guiService.SelectedObject
		if not selected then
			return nil
		end
		if not table.find(items, selected) then
			return nil
		end

		return selected
	end

	local function move(direction: number): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")
		if #items == 0 then
			return false
		end

		local selected = getCurrent()
		local startIndex = 0

		if selected then
			startIndex = table.find(items, selected) or 0
		end

		if not selected and direction < 0 then
			startIndex = #items + 1
		end

		for offset = 1, #items do
			local rawIndex = startIndex + direction * offset
			local index = rawIndex

			if wrapAround then
				index = ((rawIndex - 1) % #items) + 1
			end

			if index < 1 or index > #items then
				break
			end

			local object = items[index]
			if not canFocus(object) then
				continue
			end

			guiService.SelectedObject = object
			return true
		end

		return false
	end

	local function getItems(): { GuiObject }
		assert(not isDeleted, "Reactily focus group is deleted.")
		return table.clone(items)
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function remove(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		local index = table.find(items, object)
		if not index then
			return false
		end

		table.remove(items, index)

		if guiService.SelectedObject == object then
			guiService.SelectedObject = nil
		end

		return true
	end

	local function setWrapAround(enabled: boolean): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")
		if wrapAround == enabled then
			return false
		end

		wrapAround = enabled
		return true
	end

	return {
		add = add,
		clear = clear,
		delete = delete,
		focusFirst = focusFirst,
		focusLast = focusLast,
		focusNext = function(): boolean
			return move(1)
		end,
		focusPrevious = function(): boolean
			return move(-1)
		end,
		getCurrent = getCurrent,
		getItems = getItems,
		isDeleted = getIsDeleted,
		remove = remove,
		setWrapAround = setWrapAround,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
