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

--- @reactilyType VirtualGridRenderOptions
export type renderOptions<T> = {
	CanvasPosition: Vector2?,
	CellSize: Vector2,
	Gap: Vector2?,
	Items: { T },
	Name: string?,
	OverscanRows: number?,
	RenderItem: (item: T, index: number) -> elementModule.element,
	ScrollBarThickness: number?,
	Size: UDim2?,
	ViewportSize: Vector2,
}

export type gridRange = {
	ColumnCount: number,
	FirstIndex: number,
	FirstRow: number,
	LastIndex: number,
	LastRow: number,
	OffsetY: number,
	RowCount: number,
	TotalHeight: number,
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
function module.Resolve(
	itemCount: number,
	cellWidth: number,
	cellHeight: number,
	viewportWidth: number,
	viewportHeight: number,
	scrollOffsetY: number,
	horizontalGap: number?,
	verticalGap: number?,
	overscanRows: number?
): gridRange
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
			ColumnCount = columns,
			FirstIndex = 0,
			FirstRow = 0,
			LastIndex = 0,
			LastRow = 0,
			OffsetY = 0,
			RowCount = 0,
			TotalHeight = 0,
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
		ColumnCount = columns,
		FirstIndex = firstIndex,
		FirstRow = firstRow,
		LastIndex = lastIndex,
		LastRow = lastRow,
		OffsetY = (firstRow - 1) * strideY,
		RowCount = rows,
		TotalHeight = math.max(rows * strideY - gapY, 0),
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a virtualized vertical ScrollingFrame element for a fixed-cell grid.
--- @param options renderOptions<T> Virtual-grid render options.
--- @return element Virtualized grid ScrollingFrame element.
function module.Render<T>(options: renderOptions<T>): elementModule.element
	local gap = options.Gap or Vector2.zero
	local canvasPosition = options.CanvasPosition or Vector2.zero
	local rangeValue = module.Resolve(
		#options.Items,
		options.CellSize.X,
		options.CellSize.Y,
		options.ViewportSize.X,
		options.ViewportSize.Y,
		canvasPosition.Y,
		gap.X,
		gap.Y,
		options.OverscanRows
	)
	local children: { any } = {}
	local strideX = options.CellSize.X + gap.X
	local strideY = options.CellSize.Y + gap.Y

	if rangeValue.FirstIndex ~= 0 then
		for index = rangeValue.FirstIndex, rangeValue.LastIndex do
			local zeroIndex = index - 1
			local column = zeroIndex % rangeValue.ColumnCount
			local row = math.floor(zeroIndex / rangeValue.ColumnCount)
			children[#children + 1] = elementModule.CreateFrame({
				BackgroundTransparency = 1,
				Name = `VirtualGridItem_{index}`,
				Position = UDim2.fromOffset(column * strideX, row * strideY),
				Size = UDim2.fromOffset(options.CellSize.X, options.CellSize.Y),
			}, {
				options.RenderItem(options.Items[index], index),
			})
		end
	end

	return elementModule.CreateScrollingFrame({
		BackgroundTransparency = 1,
		CanvasPosition = canvasPosition,
		CanvasSize = UDim2.fromOffset(0, rangeValue.TotalHeight),
		Name = options.Name or "VirtualGrid",
		ScrollBarThickness = options.ScrollBarThickness or 8,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		Size = options.Size or UDim2.fromScale(1, 1),
	}, children)
end

--————————————————————————————————————————————————————————————————————--

return module
