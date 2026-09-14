--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type variableRange = {
	first: number,
	last: number,
	offset: number,
	totalSize: number,
}

export type variableVirtualList = {
	delete: () -> boolean,
	getRange: () -> variableRange,
	isDeleted: () -> boolean,
	setScrollOffset: (scrollOffset: number) -> boolean,
	setSize: (index: number, size: number) -> boolean,
	setSizes: (sizes: { number }) -> boolean,
	setViewportSize: (viewportSize: number) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

local function buildOffsets(sizes: { number }): ({ number }, number)
	local offsets = table.create(#sizes + 1, 0)
	local total = 0

	for index, size in sizes do
		assert(size >= 0, "Reactily virtual item sizes must be non-negative.")
		offsets[index] = total
		total += size
	end

	offsets[#sizes + 1] = total
	return offsets, total
end

--————————————————————————————————————————————————————————————————————--

local function findIndex(offsets: { number }, target: number, count: number): number
	local low = 1
	local high = count
	local result = count

	for _ = 1, 64 do
		if low > high then
			break
		end

		local middle = math.floor((low + high) / 2)
		local nextOffset = offsets[middle + 1]

		if nextOffset > target then
			result = middle
			high = middle - 1
			continue
		end

		low = middle + 1
	end

	return result
end

--————————————————————————————————————————————————————————————————————--

local function resolveFromOffsets(
	sizes: { number },
	offsets: { number },
	totalSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): variableRange
	local count = #sizes

	if count == 0 then
		return {
			first = 0,
			last = 0,
			offset = 0,
			totalSize = 0,
		}
	end

	local extra = math.max(math.floor(overscan or 1), 0)
	local start = math.max(scrollOffset, 0)
	local finish = start + viewportSize
	local first = math.max(findIndex(offsets, start, count) - extra, 1)
	local last = math.min(findIndex(offsets, finish, count) + extra, count)

	return {
		first = first,
		last = last,
		offset = offsets[first],
		totalSize = totalSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a cached controller for variable-size virtualized lists.
--- @param sizes {number} Initial ordered item sizes.
--- @param viewportSize number Initial visible viewport size.
--- @param overscan number? Extra items before and after the viewport.
--- @return variableVirtualList Cached variable-size virtual-list controller.
function module.new(sizes: { number }, viewportSize: number, overscan: number?): variableVirtualList
	assert(viewportSize >= 0, "Reactily virtual viewportSize must be non-negative.")

	local itemSizes = table.clone(sizes)
	local offsets, totalSize = buildOffsets(itemSizes)
	local isDeleted = false
	local scrollOffset = 0
	local viewport = viewportSize

	local function rebuild()
		offsets, totalSize = buildOffsets(itemSizes)
	end

	local function getRange(): variableRange
		assert(not isDeleted, "Reactily variable virtual list is deleted.")
		return resolveFromOffsets(itemSizes, offsets, totalSize, scrollOffset, viewport, overscan)
	end

	local function setScrollOffset(nextOffset: number): boolean
		assert(not isDeleted, "Reactily variable virtual list is deleted.")
		if scrollOffset == nextOffset then
			return false
		end

		scrollOffset = nextOffset
		return true
	end

	local function setSize(index: number, size: number): boolean
		assert(not isDeleted, "Reactily variable virtual list is deleted.")
		assert(index >= 1 and index <= #itemSizes, "Reactily virtual item index is out of range.")
		assert(size >= 0, "Reactily virtual item size must be non-negative.")
		if itemSizes[index] == size then
			return false
		end

		itemSizes[index] = size
		rebuild()
		return true
	end

	local function setSizes(nextSizes: { number }): boolean
		assert(not isDeleted, "Reactily variable virtual list is deleted.")

		if #itemSizes == #nextSizes then
			local changed = false

			for index, size in nextSizes do
				if itemSizes[index] == size then
					continue
				end
				changed = true
				break
			end

			if not changed then
				return false
			end
		end

		itemSizes = table.clone(nextSizes)
		rebuild()
		return true
	end

	local function setViewportSize(nextViewport: number): boolean
		assert(not isDeleted, "Reactily variable virtual list is deleted.")
		assert(nextViewport >= 0, "Reactily virtual viewportSize must be non-negative.")
		if viewport == nextViewport then
			return false
		end

		viewport = nextViewport
		return true
	end

	return {
		delete = function(): boolean
			if isDeleted then
				return false
			end

			isDeleted = true
			table.clear(itemSizes)
			table.clear(offsets)
			return true
		end,
		getRange = getRange,
		isDeleted = function(): boolean
			return isDeleted
		end,
		setScrollOffset = setScrollOffset,
		setSize = setSize,
		setSizes = setSizes,
		setViewportSize = setViewportSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Resolves a visible range for variable-size items.
--- @param sizes {number} Ordered item sizes.
--- @param scrollOffset number Current scroll position.
--- @param viewportSize number Visible viewport size.
--- @param overscan number? Extra item count before and after the visible range.
--- @return variableRange Calculated virtual range.
function module.resolve(sizes: { number }, scrollOffset: number, viewportSize: number, overscan: number?): variableRange
	assert(viewportSize >= 0, "Reactily virtual viewportSize must be non-negative.")

	local offsets, totalSize = buildOffsets(sizes)
	return resolveFromOffsets(sizes, offsets, totalSize, scrollOffset, viewportSize, overscan)
end

--————————————————————————————————————————————————————————————————————--

return module
