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

export type gridRange = {
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

return module
