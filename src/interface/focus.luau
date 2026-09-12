--!strict

-- manages explicit keyboard and controller focus groups

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
	getItems: () -> {GuiObject},
	isDeleted: () -> boolean,
	remove: (object: GuiObject) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function canFocus(object: GuiObject): boolean
	if not object.Parent then return false end
	if not object.Visible then return false end
	if not object.Selectable then return false end

	return true
end

--————————————————————————————————————————————————————————————————————--

function module.clearSelection()
	guiService.SelectedObject = nil
end

--————————————————————————————————————————————————————————————————————--

function module.new(): focusGroup
	local isDeleted = false
	local items: {GuiObject} = {}

	local function add(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")
		if table.find(items, object) then return false end

		items[#items + 1] = object

		return true
	end

	local function clear()
		assert(not isDeleted, "Reactily focus group is deleted.")
		table.clear(items)
	end

	local function delete(): boolean
		if isDeleted then return false end

		isDeleted = true
		table.clear(items)

		return true
	end

	local function focusFirst(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for _, object in items do
			if not canFocus(object) then continue end

			guiService.SelectedObject = object
			return true
		end

		return false
	end

	local function focusLast(): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		for index = #items, 1, -1 do
			local object = items[index]
			if not canFocus(object) then continue end

			guiService.SelectedObject = object
			return true
		end

		return false
	end

	local function getItems(): {GuiObject}
		assert(not isDeleted, "Reactily focus group is deleted.")

		return table.clone(items)
	end

	local function getIsDeleted(): boolean
		return isDeleted
	end

	local function remove(object: GuiObject): boolean
		assert(not isDeleted, "Reactily focus group is deleted.")

		local index = table.find(items, object)
		if not index then return false end

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
