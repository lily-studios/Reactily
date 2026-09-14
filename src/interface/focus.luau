--!strict

-- provides grouped GUI focus management for selectable interface objects

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
	getItems: () -> { GuiObject },
	isDeleted: () -> boolean,
	remove: (object: GuiObject) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function canFocusObject(object: GuiObject): boolean
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

--- Clears the currently selected Roblox GUI object.
function module.clearSelection()
	if guiService.SelectedObject == nil then
		return
	end

	guiService.SelectedObject = nil
end

--————————————————————————————————————————————————————————————————————--

--- Creates an ordered focus group for selectable GUI objects.
--- @return focusGroup A new focus group.
function module.new(): focusGroup
	local isDeleted = false
	local items: { GuiObject } = {}

	--- Adds a GUI object to the focus group.
	--- Duplicate objects are not added.
	--- @param object GuiObject Object to add.
	--- @return boolean Whether the object was added.
	local function add(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		if table.find(items, object) then
			return false
		end

		items[#items + 1] = object

		return true
	end

	--- Removes all tracked objects from the focus group.
	local function clear()
		assert(not isDeleted, "Reactily focus group is deleted.")

		if #items == 0 then
			return
		end

		table.clear(items)
	end

	--- Deletes the focus group and clears all tracked objects.
	--- @return boolean Whether deletion occurred.
	local function delete(): boolean
		if isDeleted then
			return false
		end

		isDeleted = true

		table.clear(items)

		return true
	end

	--- Focuses the first valid selectable object in the group.
	--- @return boolean Whether an object was focused.
	local function focusFirst(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for _, object in items do
			if not canFocusObject(object) then
				continue
			end

			if guiService.SelectedObject ~= object then
				guiService.SelectedObject = object
			end

			return true
		end

		return false
	end

	--- Focuses the last valid selectable object in the group.
	--- @return boolean Whether an object was focused.
	local function focusLast(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for index = #items, 1, -1 do
			local object = items[index]

			if not canFocusObject(object) then
				continue
			end

			if guiService.SelectedObject ~= object then
				guiService.SelectedObject = object
			end

			return true
		end

		return false
	end

	--- Returns a copy of the GUI objects currently tracked by the group.
	--- @return {GuiObject} Tracked objects in focus order.
	local function getItems(): { GuiObject }
		assert(not isDeleted, "Reactily focus group is deleted.")

		return table.clone(items)
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	--- Removes a GUI object from the focus group.
	--- @param object GuiObject Object to remove.
	--- @return boolean Whether the object was found and removed.
	local function remove(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		local index = table.find(items, object)

		if not index then
			return false
		end

		table.remove(items, index)

		return true
	end

	return {
		add = add,
		clear = clear,
		delete = delete,
		focusFirst = focusFirst,
		focusLast = focusLast,
		getItems = getItems,
		isDeleted = getIsDeleted,
		remove = remove,
	}
end

--————————————————————————————————————————————————————————————————————--

return module
