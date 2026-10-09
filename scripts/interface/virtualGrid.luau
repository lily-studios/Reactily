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

type RenderOptions<T> = {
	CanvasPosition: Vector2?,
	CellSize: Vector2,
	gap: Vector2?,
	items: { T },
	Name: string?,
	overscanRows: number?,
	renderItem: (item: T, index: number) -> elementModule.Element,
	ScrollBarThickness: number?,
	Size: UDim2?,
	viewportSize: Vector2,
}

export type GridRange = {
	columnCount: number,
	firstIndex: number,
	firstRow: number,
	lastIndex: number,
	lastRow: number,
	offsetY: number,
	rowCount: number,
	totalHeight: number,
}

--————————————————————————————————————————————————————————————————————--

--- Resolves the visible item range for a fixed-size grid.
--- @param itemCount number Total item count.
--- @param cellWidth number Cell width in pixels.
--- @param cellHeight number Cell height in pixels.
--- @param viewportWidth number Visible viewport width.
--- @param viewportHeight number Visible viewport height.
--- @param scrollOffsetY number Vertical scroll offset.
--- @param horizontalGap number? Horizontal spacing between cells.
--- @param verticalGap number? Vertical spacing between rows.
--- @param overscanRows number? Extra rows rendered above and below the viewport.
--- @return gridRange Calculated visible grid range.
function module.resolve(
	itemCount: number,
	cellWidth: number,
	cellHeight: number,
	viewportWidth: number,
	viewportHeight: number,
	scrollOffsetY: number,
	horizontalGap: number?,
	verticalGap: number?,
	overscanRows: number?
): GridRange
	assert(itemCount >= 0, "Reactily grid itemCount must be non-negative.")
	assert(cellWidth > 0, "Reactily grid cellWidth must be greater than zero.")
	assert(cellHeight > 0, "Reactily grid cellHeight must be greater than zero.")

	local gapX = math.max(horizontalGap or 0, 0)
	local gapY = math.max(verticalGap or 0, 0)
	local strideX = cellWidth + gapX
	local strideY = cellHeight + gapY
	local columns = math.max(math.floor((viewportWidth + gapX) / strideX), 1)
	local rows = math.ceil(itemCount / columns)
	local overscan = math.max(math.floor(overscanRows or 1), 0)

	if itemCount == 0 then
		return {
			columnCount = columns,
			firstIndex = 0,
			firstRow = 0,
			lastIndex = 0,
			lastRow = 0,
			offsetY = 0,
			rowCount = 0,
			totalHeight = 0,
		}
	end

	local firstRow = math.floor(math.max(scrollOffsetY, 0) / strideY) + 1 - overscan
	local visibleRows = math.ceil(viewportHeight / strideY) + overscan * 2
	local lastRow = firstRow + visibleRows - 1

	firstRow = math.clamp(firstRow, 1, rows)
	lastRow = math.clamp(lastRow, firstRow, rows)

	local firstIndex = (firstRow - 1) * columns + 1
	local lastIndex = math.min(lastRow * columns, itemCount)

	return {
		columnCount = columns,
		firstIndex = firstIndex,
		firstRow = firstRow,
		lastIndex = lastIndex,
		lastRow = lastRow,
		offsetY = (firstRow - 1) * strideY,
		rowCount = rows,
		totalHeight = math.max(rows * strideY - gapY, 0),
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a virtualized vertical ScrollingFrame element for a fixed-cell grid.
--- @param options renderOptions<T> Virtual-grid render options.
--- @return element Virtualized grid ScrollingFrame element.
function module.render<T>(options: RenderOptions<T>): elementModule.Element
	local gap = options.gap or Vector2.zero
	local canvasPosition = options.CanvasPosition or Vector2.zero
	local rangeValue = module.resolve(
		#options.items,
		options.CellSize.X,
		options.CellSize.Y,
		options.viewportSize.X,
		options.viewportSize.Y,
		canvasPosition.Y,
		gap.X,
		gap.Y,
		options.overscanRows
	)
	local children: { any } = {}
	local strideX = options.CellSize.X + gap.X
	local strideY = options.CellSize.Y + gap.Y

	if rangeValue.firstIndex ~= 0 then
		for index = rangeValue.firstIndex, rangeValue.lastIndex do
			local zeroIndex = index - 1
			local column = zeroIndex % rangeValue.columnCount
			local row = math.floor(zeroIndex / rangeValue.columnCount)
			children[#children + 1] = elementModule.createFrame({
				BackgroundTransparency = 1,
				Name = `VirtualGridItem_{index}`,
				Position = UDim2.fromOffset(column * strideX, row * strideY),
				Size = UDim2.fromOffset(options.CellSize.X, options.CellSize.Y),
			}, {
				options.renderItem(options.items[index], index),
			})
		end
	end

	return elementModule.createScrollingFrame({
		BackgroundTransparency = 1,
		CanvasPosition = canvasPosition,
		CanvasSize = UDim2.fromOffset(0, rangeValue.totalHeight),
		Name = options.Name or "VirtualGrid",
		ScrollBarThickness = options.ScrollBarThickness or 8,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = options.Size or UDim2.fromScale(1, 1),
	}, children)
end

--————————————————————————————————————————————————————————————————————--


-- Canonical public API names (discoverable directly from Luau).
module.resolveVirtualGrid = module.resolve
export type VirtualGridRenderOptions<T> = RenderOptions<T>

return module
