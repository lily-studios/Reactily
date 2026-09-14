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

export type range = {
	first: number,
	last: number,
	offset: number,
	totalSize: number,
}

export type virtualList = {
	delete: () -> boolean,
	getRange: () -> range,
	isDeleted: () -> boolean,
	setItemCount: (itemCount: number) -> boolean,
	setScrollOffset: (scrollOffset: number) -> boolean,
	setViewportSize: (viewportSize: number) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Resolves a visible range for a fixed-size virtual list.
--- @param itemCount number Total number of items.
--- @param itemSize number Size of each item along the scrolling axis.
--- @param scrollOffset number Current scroll offset.
--- @param viewportSize number Visible viewport size.
--- @param overscan number? Extra items rendered before and after the viewport.
--- @return range Calculated visible range.
function module.resolve(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): range
	assert(itemCount >= 0, "Reactily itemCount must be non-negative.")
	assert(itemSize > 0, "Reactily itemSize must be greater than zero.")
	assert(viewportSize >= 0, "Reactily viewportSize must be non-negative.")

	if itemCount == 0 then
		return {
			first = 0,
			last = 0,
			offset = 0,
			totalSize = 0,
		}
	end

	local extra = math.max(math.floor(overscan or 2), 0)
	local first = math.floor(math.max(scrollOffset, 0) / itemSize) + 1 - extra
	local visibleCount = math.ceil(viewportSize / itemSize) + extra * 2
	local last = first + visibleCount - 1

	first = math.clamp(first, 1, itemCount)
	last = math.clamp(last, first, itemCount)

	return {
		first = first,
		last = last,
		offset = (first - 1) * itemSize,
		totalSize = itemCount * itemSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a small stateful virtual-list range controller.
--- @param itemCount number Initial item count.
--- @param itemSize number Fixed item size.
--- @param viewportSize number Initial viewport size.
--- @param overscan number? Extra item count outside the viewport.
--- @return virtualList New virtual-list controller.
function module.new(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): virtualList
	local count = itemCount
	local isDeleted = false
	local offset = 0
	local viewport = viewportSize

	local function getRange(): range
		assert(not isDeleted, "Reactily virtual list is deleted.")
		return module.resolve(count, itemSize, offset, viewport, overscan)
	end

	local function setItemCount(nextCount: number): boolean
		assert(not isDeleted, "Reactily virtual list is deleted.")
		assert(nextCount >= 0, "Reactily itemCount must be non-negative.")
		if count == nextCount then
			return false
		end

		count = nextCount
		return true
	end

	local function setScrollOffset(nextOffset: number): boolean
		assert(not isDeleted, "Reactily virtual list is deleted.")
		if offset == nextOffset then
			return false
		end

		offset = nextOffset
		return true
	end

	local function setViewportSize(nextViewport: number): boolean
		assert(not isDeleted, "Reactily virtual list is deleted.")
		assert(nextViewport >= 0, "Reactily viewportSize must be non-negative.")
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
			return true
		end,
		getRange = getRange,
		isDeleted = function(): boolean
			return isDeleted
		end,
		setItemCount = setItemCount,
		setScrollOffset = setScrollOffset,
		setViewportSize = setViewportSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Returns the items contained inside a resolved virtual range.
--- @param items {T} Complete item collection.
--- @param rangeValue range Resolved range.
--- @return {T} Visible item slice.
function module.slice<T>(items: { T }, rangeValue: range): { T }
	if rangeValue.first == 0 then
		return {}
	end

	local output: { T } = table.create(rangeValue.last - rangeValue.first + 1)

	for index = rangeValue.first, rangeValue.last do
		output[#output + 1] = items[index]
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
