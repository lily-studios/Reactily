--[[
	Reactily · Lily Studios

	Copyright (c) Lily Studios and contributors.
	Licensed under the MIT License.
	See LICENSE in the repository root for full terms.
]]

--!strict

--————————————————————————————————————————————————————————————————————--

local elementModule = require(script.Parent.Parent.virtual.element)

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type range = {
	First: number,
	Last: number,
	Offset: number,
	TotalSize: number,
}

--- @reactilyType VirtualListRenderOptions
export type renderOptions<T> = {
	CanvasPosition: Vector2?,
	ItemSize: number,
	Items: { T },
	Name: string?,
	Overscan: number?,
	RenderItem: (item: T, index: number) -> elementModule.element,
	ScrollBarThickness: number?,
	Size: UDim2?,
	ViewportSize: number,
}

export type virtualList = {
	Delete: () -> boolean,
	GetRange: () -> range,
	IsDeleted: () -> boolean,
	SetItemCount: (itemCount: number) -> boolean,
	SetScrollOffset: (scrollOffset: number) -> boolean,
	SetViewportSize: (viewportSize: number) -> boolean,
}

--————————————————————————————————————————————————————————————————————--

--- Resolves a visible range for a fixed-size virtual list.
--- @param itemCount number Total number of items.
--- @param itemSize number Size of each item along the scrolling axis.
--- @param scrollOffset number Current scroll offset.
--- @param viewportSize number Visible viewport size.
--- @param overscan number? Extra items rendered before and after the viewport.
--- @return range Calculated visible range.
function module.Resolve(
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
			First = 0,
			Last = 0,
			Offset = 0,
			TotalSize = 0,
		}
	end

	local extra = math.max(math.floor(overscan or 2), 0)
	local first = math.floor(math.max(scrollOffset, 0) / itemSize) + 1 - extra
	local visibleCount = math.ceil(viewportSize / itemSize) + extra * 2
	local last = first + visibleCount - 1

	first = math.clamp(first, 1, itemCount)
	last = math.clamp(last, first, itemCount)

	return {
		First = first,
		Last = last,
		Offset = (first - 1) * itemSize,
		TotalSize = itemCount * itemSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a small stateful virtual-list range controller.
--- @param itemCount number Initial item count.
--- @param itemSize number Fixed item size.
--- @param viewportSize number Initial viewport size.
--- @param overscan number? Extra item count outside the viewport.
--- @return virtualList New virtual-list controller.
function module.New(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): virtualList
	local count = itemCount
	local isDeleted = false
	local offset = 0
	local viewport = viewportSize

	local function getRange(): range
		assert(not isDeleted, "Reactily virtual list is deleted.")
		return module.Resolve(count, itemSize, offset, viewport, overscan)
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
		Delete = function(): boolean
			if isDeleted then
				return false
			end
			isDeleted = true
			return true
		end,
		GetRange = getRange,
		IsDeleted = function(): boolean
			return isDeleted
		end,
		SetItemCount = setItemCount,
		SetScrollOffset = setScrollOffset,
		SetViewportSize = setViewportSize,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Returns the items contained inside a resolved virtual range.
--- @param items {T} Complete item collection.
--- @param rangeValue range Resolved range.
--- @return {T} Visible item slice.
function module.Slice<T>(items: { T }, rangeValue: range): { T }
	if rangeValue.First == 0 then
		return {}
	end

	local output: { T } = table.create(rangeValue.Last - rangeValue.First + 1)

	for index = rangeValue.First, rangeValue.Last do
		output[#output + 1] = items[index]
	end

	return output
end

--————————————————————————————————————————————————————————————————————--

--- Creates a virtualized vertical ScrollingFrame element for a fixed-size item list.
--- @param options renderOptions<T> Virtual-list render options.
--- @return element Virtualized ScrollingFrame element.
function module.Render<T>(options: renderOptions<T>): elementModule.element
	local canvasPosition = options.CanvasPosition or Vector2.zero
	local rangeValue =
		module.Resolve(#options.Items, options.ItemSize, canvasPosition.Y, options.ViewportSize, options.Overscan)
	local children: { any } = {}

	if rangeValue.First ~= 0 then
		for index = rangeValue.First, rangeValue.Last do
			local item = options.Items[index]
			children[#children + 1] = elementModule.CreateFrame({
				BackgroundTransparency = 1,
				LayoutOrder = index,
				Name = `VirtualItem_{index}`,
				Position = UDim2.fromOffset(0, (index - 1) * options.ItemSize),
				Size = UDim2.new(1, 0, 0, options.ItemSize),
			}, {
				options.RenderItem(item, index),
			})
		end
	end

	return elementModule.CreateScrollingFrame({
		BackgroundTransparency = 1,
		CanvasPosition = canvasPosition,
		CanvasSize = UDim2.fromOffset(0, rangeValue.TotalSize),
		Name = options.Name or "VirtualList",
		ScrollBarThickness = options.ScrollBarThickness or 8,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = options.Size or UDim2.fromScale(1, 1),
	}, children)
end

--————————————————————————————————————————————————————————————————————--

return module
