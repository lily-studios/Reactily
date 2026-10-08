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

--- @reactilyType CommonOptions
export type commonOptions = {
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundTransparency: number?,
	LayoutOrder: number?,
	Name: string?,
	Padding: number?,
	Position: UDim2?,
	Size: UDim2?,
	ZIndex: number?,
}

--- @reactilyType ListOptions
export type listOptions = {
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundTransparency: number?,
	FillDirection: Enum.FillDirection?,
	Gap: number?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	LayoutOrder: number?,
	Name: string?,
	Padding: number?,
	Position: UDim2?,
	Size: UDim2?,
	SortOrder: Enum.SortOrder?,
	VerticalAlignment: Enum.VerticalAlignment?,
	Wraps: boolean?,
	ZIndex: number?,
}

--- @reactilyType GridOptions
export type gridOptions = {
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundTransparency: number?,
	CellPadding: UDim2?,
	CellSize: UDim2,
	FillDirection: Enum.FillDirection?,
	FillDirectionMaxCells: number?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	LayoutOrder: number?,
	Name: string?,
	Padding: number?,
	Position: UDim2?,
	Size: UDim2?,
	SortOrder: Enum.SortOrder?,
	StartCorner: Enum.StartCorner?,
	VerticalAlignment: Enum.VerticalAlignment?,
	ZIndex: number?,
}

type frameOptionSource = commonOptions | listOptions | gridOptions

--————————————————————————————————————————————————————————————————————--

local function createFrameProps(options: frameOptionSource?): elementModule.frameProps
	local backgroundTransparency = 1

	if options then
		if options.BackgroundTransparency ~= nil then
			backgroundTransparency = options.BackgroundTransparency
		end

		return {
			AnchorPoint = options.AnchorPoint,
			AutomaticSize = options.AutomaticSize,
			BackgroundTransparency = backgroundTransparency,
			LayoutOrder = options.LayoutOrder,
			Name = options.Name,
			Position = options.Position,
			Size = options.Size,
			ZIndex = options.ZIndex,
		}
	end

	return {
		BackgroundTransparency = backgroundTransparency,
	}
end

--————————————————————————————————————————————————————————————————————--

local function createPadding(padding: number?): elementModule.element?
	if padding == nil then
		return nil
	end

	local value = UDim.new(0, padding)

	return elementModule.CreateUIPadding({
		PaddingBottom = value,
		PaddingLeft = value,
		PaddingRight = value,
		PaddingTop = value,
	})
end

--————————————————————————————————————————————————————————————————————--

local function appendChildren(outputChildren: { any }, children: { any })
	for _, child in children do
		outputChildren[#outputChildren + 1] = child
	end
end

--————————————————————————————————————————————————————————————————————--

local function resolveFillDirection(options: listOptions?, override: Enum.FillDirection?): Enum.FillDirection
	if override then
		return override
	end

	if options then
		if options.FillDirection then
			return options.FillDirection
		end
	end

	return Enum.FillDirection.Vertical
end

--————————————————————————————————————————————————————————————————————--

local function resolveHorizontalAlignment(options: listOptions?): Enum.HorizontalAlignment
	if options then
		if options.HorizontalAlignment then
			return options.HorizontalAlignment
		end
	end

	return Enum.HorizontalAlignment.Left
end

--————————————————————————————————————————————————————————————————————--

local function resolveSortOrder(options: listOptions?): Enum.SortOrder
	if options then
		if options.SortOrder then
			return options.SortOrder
		end
	end

	return Enum.SortOrder.LayoutOrder
end

--————————————————————————————————————————————————————————————————————--

local function resolveVerticalAlignment(options: listOptions?): Enum.VerticalAlignment
	if options then
		if options.VerticalAlignment then
			return options.VerticalAlignment
		end
	end

	return Enum.VerticalAlignment.Top
end

--————————————————————————————————————————————————————————————————————--

local function resolveWraps(options: listOptions?, override: boolean?): boolean
	if override ~= nil then
		return override
	end

	if options then
		if options.Wraps ~= nil then
			return options.Wraps
		end
	end

	return false
end

--————————————————————————————————————————————————————————————————————--

local function resolveGap(options: listOptions?): number
	if not options then
		return 0
	end

	if options.Gap == nil then
		return 0
	end

	return options.Gap
end

--————————————————————————————————————————————————————————————————————--

local function createList(
	options: listOptions?,
	children: { any },
	fillDirectionOverride: Enum.FillDirection?,
	wrapsOverride: boolean?
): elementModule.element
	local gap = resolveGap(options)

	local layout = elementModule.CreateUIListLayout({
		FillDirection = resolveFillDirection(options, fillDirectionOverride),
		HorizontalAlignment = resolveHorizontalAlignment(options),
		Padding = UDim.new(0, gap),
		SortOrder = resolveSortOrder(options),
		VerticalAlignment = resolveVerticalAlignment(options),
		Wraps = resolveWraps(options, wrapsOverride),
	})

	local outputChildren: { any } = {
		layout,
	}

	local paddingValue: number? = nil

	if options then
		paddingValue = options.Padding
	end

	local padding = createPadding(paddingValue)

	if padding then
		outputChildren[#outputChildren + 1] = padding
	end

	appendChildren(outputChildren, children)

	return elementModule.CreateFrame(createFrameProps(options), outputChildren)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a transparent horizontal list container.
--- @param options listOptions? Layout options.
--- @param children {any} Child elements.
--- @return element Layout element.
function module.Horizontal(options: listOptions?, children: { any }): elementModule.element
	return createList(options, children, Enum.FillDirection.Horizontal, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a transparent vertical list container.
--- @param options listOptions? Layout options.
--- @param children {any} Child elements.
--- @return element Layout element.
function module.Vertical(options: listOptions?, children: { any }): elementModule.element
	return createList(options, children, Enum.FillDirection.Vertical, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a transparent wrapping list container.
--- @param options listOptions? Layout options.
--- @param children {any} Child elements.
--- @return element Layout element.
function module.Wrap(options: listOptions?, children: { any }): elementModule.element
	return createList(options, children, nil, true)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a grid container backed by UIGridLayout.
--- @param options gridOptions Grid options.
--- @param children {any} Child elements.
--- @return element Grid element.
function module.Grid(options: gridOptions, children: { any }): elementModule.element
	local cellPadding = options.CellPadding

	if cellPadding == nil then
		cellPadding = UDim2.fromOffset(0, 0)
	end

	local fillDirection = options.FillDirection

	if fillDirection == nil then
		fillDirection = Enum.FillDirection.Horizontal
	end

	local fillDirectionMaxCells = options.FillDirectionMaxCells

	if fillDirectionMaxCells == nil then
		fillDirectionMaxCells = 0
	end

	local horizontalAlignment = options.HorizontalAlignment

	if horizontalAlignment == nil then
		horizontalAlignment = Enum.HorizontalAlignment.Left
	end

	local sortOrder = options.SortOrder

	if sortOrder == nil then
		sortOrder = Enum.SortOrder.LayoutOrder
	end

	local startCorner = options.StartCorner

	if startCorner == nil then
		startCorner = Enum.StartCorner.TopLeft
	end

	local verticalAlignment = options.VerticalAlignment

	if verticalAlignment == nil then
		verticalAlignment = Enum.VerticalAlignment.Top
	end

	local layout = elementModule.CreateUIGridLayout({
		CellPadding = cellPadding,
		CellSize = options.CellSize,
		FillDirection = fillDirection,
		FillDirectionMaxCells = fillDirectionMaxCells,
		HorizontalAlignment = horizontalAlignment,
		SortOrder = sortOrder,
		StartCorner = startCorner,
		VerticalAlignment = verticalAlignment,
	})

	local outputChildren: { any } = {
		layout,
	}

	local padding = createPadding(options.Padding)

	if padding then
		outputChildren[#outputChildren + 1] = padding
	end

	appendChildren(outputChildren, children)

	return elementModule.CreateFrame(createFrameProps(options), outputChildren)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a transparent stacking container where children share the same bounds.
--- @param options commonOptions? Container options.
--- @param children {any} Child elements.
--- @return element Stack element.
function module.Stack(options: commonOptions?, children: { any }): elementModule.element
	return elementModule.CreateFrame(createFrameProps(options), children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a container whose children are centered by UIListLayout.
--- @param options commonOptions? Container options.
--- @param children {any} Child elements.
--- @return element Centered element.
function module.Center(options: commonOptions?, children: { any }): elementModule.element
	local layout = elementModule.CreateUIListLayout({
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		VerticalAlignment = Enum.VerticalAlignment.Center,
	})

	local outputChildren: { any } = {
		layout,
	}

	local paddingValue: number? = nil

	if options then
		paddingValue = options.Padding
	end

	local padding = createPadding(paddingValue)

	if padding then
		outputChildren[#outputChildren + 1] = padding
	end

	appendChildren(outputChildren, children)

	return elementModule.CreateFrame(createFrameProps(options), outputChildren)
end

--————————————————————————————————————————————————————————————————————--

return module
