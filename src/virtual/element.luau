--!strict

-- defines Reactily virtual elements and typed Roblox interface props

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

export type attributeValue =
	boolean
	| BrickColor
	| CFrame
	| Color3
	| ColorSequence
	| NumberRange
	| NumberSequence
	| number
	| Rect
	| string
	| UDim
	| UDim2
	| Vector2
	| Vector3

export type attributeMap = {[string]: attributeValue}

export type refCallback<T> = (instance: T?) -> ()

export type hostMetadataProps<T> = {
	attributes: attributeMap?,
	key: string?,
	name: string?,
	ref: refCallback<T>?,
	tags: {string}?,

	onAncestryChanged: ((child: Instance, parent: Instance?) -> ())?,
	onChanged: ((property: string) -> ())?,
}

export type commonGuiProps<T> = hostMetadataProps<T> & {
	active: boolean?,
	anchorPoint: Vector2?,
	automaticSize: Enum.AutomaticSize?,
	backgroundColor3: Color3?,
	backgroundTransparency: number?,
	borderColor3: Color3?,
	borderMode: Enum.BorderMode?,
	borderSizePixel: number?,
	clipsDescendants: boolean?,
	layoutOrder: number?,
	nextSelectionDown: GuiObject?,
	nextSelectionLeft: GuiObject?,
	nextSelectionRight: GuiObject?,
	nextSelectionUp: GuiObject?,
	position: UDim2?,
	rotation: number?,
	selectable: boolean?,
	selectionOrder: number?,
	size: UDim2?,
	sizeConstraint: Enum.SizeConstraint?,
	visible: boolean?,
	zIndex: number?,

	onInputBegan: ((input: InputObject) -> ())?,
	onInputChanged: ((input: InputObject) -> ())?,
	onInputEnded: ((input: InputObject) -> ())?,
	onMouseEnter: (() -> ())?,
	onMouseLeave: (() -> ())?,
	onSelectionGained: (() -> ())?,
	onSelectionLost: (() -> ())?,
}

export type textProps = {
	font: Enum.Font?,
	fontFace: Font?,
	lineHeight: number?,
	maxVisibleGraphemes: number?,
	richText: boolean?,
	text: string?,
	textColor3: Color3?,
	textDirection: Enum.TextDirection?,
	textScaled: boolean?,
	textSize: number?,
	textStrokeColor3: Color3?,
	textStrokeTransparency: number?,
	textTransparency: number?,
	textTruncate: Enum.TextTruncate?,
	textWrapped: boolean?,
	textXAlignment: Enum.TextXAlignment?,
	textYAlignment: Enum.TextYAlignment?,
}

export type imageProps = {
	image: string?,
	imageColor3: Color3?,
	imageRectOffset: Vector2?,
	imageRectSize: Vector2?,
	imageTransparency: number?,
	resampleMode: Enum.ResamplerMode?,
	scaleType: Enum.ScaleType?,
	sliceCenter: Rect?,
	sliceScale: number?,
	tileSize: UDim2?,
}

export type buttonEvents = {
	onActivated: ((input: InputObject, clickCount: number) -> ())?,
	onMouseButton1Click: (() -> ())?,
	onMouseButton1Down: ((x: number, y: number) -> ())?,
	onMouseButton1Up: ((x: number, y: number) -> ())?,
	onMouseButton2Click: (() -> ())?,
	onMouseButton2Down: ((x: number, y: number) -> ())?,
	onMouseButton2Up: ((x: number, y: number) -> ())?,
}

export type billboardGuiProps = hostMetadataProps<BillboardGui> & {
	active: boolean?,
	adornee: Instance?,
	alwaysOnTop: boolean?,
	brightness: number?,
	clipsDescendants: boolean?,
	enabled: boolean?,
	extentsOffset: Vector3?,
	extentsOffsetWorldSpace: Vector3?,
	lightInfluence: number?,
	maxDistance: number?,
	playerToHideFrom: Player?,
	size: UDim2?,
	sizeOffset: Vector2?,
	studsOffset: Vector3?,
	studsOffsetWorldSpace: Vector3?,
	zIndexBehavior: Enum.ZIndexBehavior?,
}

export type canvasGroupProps = commonGuiProps<CanvasGroup> & {
	groupColor3: Color3?,
	groupTransparency: number?,
}

export type frameProps = commonGuiProps<Frame> & {
	style: Enum.FrameStyle?,
}

export type imageButtonProps = commonGuiProps<ImageButton> & imageProps & buttonEvents & {
	autoButtonColor: boolean?,
	hoverImage: string?,
	modal: boolean?,
	pressedImage: string?,
	selected: boolean?,
}

export type imageLabelProps = commonGuiProps<ImageLabel> & imageProps

export type screenGuiProps = hostMetadataProps<ScreenGui> & {
	clipToDeviceSafeArea: boolean?,
	displayOrder: number?,
	enabled: boolean?,
	ignoreGuiInset: boolean?,
	resetOnSpawn: boolean?,
	safeAreaCompatibility: Enum.SafeAreaCompatibility?,
	screenInsets: Enum.ScreenInsets?,
	zIndexBehavior: Enum.ZIndexBehavior?,
}

export type scrollingFrameProps = commonGuiProps<ScrollingFrame> & {
	automaticCanvasSize: Enum.AutomaticSize?,
	bottomImage: string?,
	canvasPosition: Vector2?,
	canvasSize: UDim2?,
	elasticBehavior: Enum.ElasticBehavior?,
	midImage: string?,
	scrollBarImageColor3: Color3?,
	scrollBarImageTransparency: number?,
	scrollBarThickness: number?,
	scrollingDirection: Enum.ScrollingDirection?,
	scrollingEnabled: boolean?,
	topImage: string?,
	verticalScrollBarInset: Enum.ScrollBarInset?,
	verticalScrollBarPosition: Enum.VerticalScrollBarPosition?,
}

export type surfaceGuiProps = hostMetadataProps<SurfaceGui> & {
	active: boolean?,
	adornee: BasePart?,
	alwaysOnTop: boolean?,
	brightness: number?,
	canvasSize: Vector2?,
	clipsDescendants: boolean?,
	enabled: boolean?,
	face: Enum.NormalId?,
	lightInfluence: number?,
	maxDistance: number?,
	pixelsPerStud: number?,
	sizingMode: Enum.SurfaceGuiSizingMode?,
	toolPunchThroughDistance: number?,
	zIndexBehavior: Enum.ZIndexBehavior?,
	zOffset: number?,
}

export type textBoxProps = commonGuiProps<TextBox> & textProps & {
	clearTextOnFocus: boolean?,
	cursorPosition: number?,
	multiLine: boolean?,
	placeholderColor3: Color3?,
	placeholderText: string?,
	selectionStart: number?,
	showNativeInput: boolean?,
	textEditable: boolean?,

	onFocused: (() -> ())?,
	onFocusLost: ((enterPressed: boolean, input: InputObject?) -> ())?,
}

export type textButtonProps = commonGuiProps<TextButton> & textProps & buttonEvents & {
	autoButtonColor: boolean?,
	modal: boolean?,
	selected: boolean?,
	style: Enum.ButtonStyle?,
}

export type textLabelProps = commonGuiProps<TextLabel> & textProps

export type videoFrameProps = commonGuiProps<VideoFrame> & {
	looped: boolean?,
	playing: boolean?,
	timePosition: number?,
	video: string?,
	volume: number?,
}

export type viewportFrameProps = commonGuiProps<ViewportFrame> & {
	ambient: Color3?,
	currentCamera: Camera?,
	imageColor3: Color3?,
	imageTransparency: number?,
	lightColor: Color3?,
	lightDirection: Vector3?,
}

export type uiAspectRatioConstraintProps = hostMetadataProps<UIAspectRatioConstraint> & {
	aspectRatio: number?,
	aspectType: Enum.AspectType?,
	dominantAxis: Enum.DominantAxis?,
}

export type uiCornerProps = hostMetadataProps<UICorner> & {
	cornerRadius: UDim?,
}

export type uiGradientProps = hostMetadataProps<UIGradient> & {
	color: ColorSequence?,
	enabled: boolean?,
	offset: Vector2?,
	rotation: number?,
	transparency: NumberSequence?,
}

export type uiGridLayoutProps = hostMetadataProps<UIGridLayout> & {
	cellPadding: UDim2?,
	cellSize: UDim2?,
	fillDirection: Enum.FillDirection?,
	fillDirectionMaxCells: number?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	sortOrder: Enum.SortOrder?,
	startCorner: Enum.StartCorner?,
	verticalAlignment: Enum.VerticalAlignment?,
}

export type uiListLayoutProps = hostMetadataProps<UIListLayout> & {
	fillDirection: Enum.FillDirection?,
	horizontalAlignment: Enum.HorizontalAlignment?,
	horizontalFlex: Enum.UIFlexAlignment?,
	itemLineAlignment: Enum.ItemLineAlignment?,
	padding: UDim?,
	sortOrder: Enum.SortOrder?,
	verticalAlignment: Enum.VerticalAlignment?,
	verticalFlex: Enum.UIFlexAlignment?,
	wraps: boolean?,
}

export type uiPaddingProps = hostMetadataProps<UIPadding> & {
	paddingBottom: UDim?,
	paddingLeft: UDim?,
	paddingRight: UDim?,
	paddingTop: UDim?,
}

export type uiPageLayoutProps = hostMetadataProps<UIPageLayout> & {
	animated: boolean?,
	circular: boolean?,
	easingDirection: Enum.EasingDirection?,
	easingStyle: Enum.EasingStyle?,
	gamepadInputEnabled: boolean?,
	padding: UDim?,
	scrollWheelInputEnabled: boolean?,
	touchInputEnabled: boolean?,
	tweenTime: number?,
}

export type uiScaleProps = hostMetadataProps<UIScale> & {
	scale: number?,
}

export type uiSizeConstraintProps = hostMetadataProps<UISizeConstraint> & {
	maximumSize: Vector2?,
	minimumSize: Vector2?,
}

export type uiStrokeProps = hostMetadataProps<UIStroke> & {
	applyStrokeMode: Enum.ApplyStrokeMode?,
	color: Color3?,
	enabled: boolean?,
	lineJoinMode: Enum.LineJoinMode?,
	thickness: number?,
	transparency: number?,
}

export type uiTextSizeConstraintProps = hostMetadataProps<UITextSizeConstraint> & {
	maximumTextSize: number?,
	minimumTextSize: number?,
}

export type genericProps = {
	[string]: any,
}

export type element =
	{
		children: {element},
		className: string,
		key: string?,
		kind: "host",
		props: genericProps,
	}
	| {
		children: {element},
		component: (props: genericProps) -> element?,
		key: string?,
		kind: "component",
		props: genericProps,
	}
	| {
		children: {element},
		key: string?,
		kind: "fragment",
		props: genericProps,
	}
	| {
		children: {element},
		key: string?,
		kind: "portal",
		props: genericProps,
		target: Instance,
	}

export type component<P> = (props: P) -> element?

--————————————————————————————————————————————————————————————————————--

local function copyChildren(children: {element}?): {element}
	if not children then return {} end

	return table.clone(children)
end

--————————————————————————————————————————————————————————————————————--

local function copyProps<T>(props: T?): genericProps
	if not props then return {} end

	return table.clone(props :: any)
end

--————————————————————————————————————————————————————————————————————--

local function getKey(props: genericProps?): string?
	if not props then return nil end
	if type(props.key) ~= "string" then return nil end

	return props.key
end

--————————————————————————————————————————————————————————————————————--

local function host(
	className: string,
	props: genericProps?,
	children: {element}?
): element
	return {
		children = copyChildren(children),
		className = className,
		key = getKey(props),
		kind = "host",
		props = copyProps(props),
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed BillboardGui element.
--- @param props billboardGuiProps? BillboardGui properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A BillboardGui host element.
function module.createBillboardGui(
	props: billboardGuiProps?,
	children: {element}?
): element
	return host("BillboardGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed CanvasGroup element.
--- @param props canvasGroupProps? CanvasGroup properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A CanvasGroup host element.
function module.createCanvasGroup(
	props: canvasGroupProps?,
	children: {element}?
): element
	return host("CanvasGroup", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a function component element.
--- @param componentValue component<P> Component function to render.
--- @param props P Props passed to the component.
--- @param children {element}? Child elements associated with the component.
--- @param key string? Stable reconciliation key.
--- @return element A component element.
function module.createComponent<P>(
	componentValue: component<P>,
	props: P,
	children: {element}?,
	key: string?
): element
	local genericPropsValue = copyProps(props)

	return {
		children = copyChildren(children),
		component = componentValue :: any,
		key = key,
		kind = "component",
		props = genericPropsValue,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a generic Roblox host element.
--- Prefer class-specific creators when available for stronger prop autocomplete.
--- @param className string Roblox class name passed to Instance.new().
--- @param props genericProps? Generic host properties.
--- @param children {element}? Child Reactily elements.
--- @return element A generic host element.
function module.createElement(
	className: string,
	props: genericProps?,
	children: {element}?
): element
	assert(className ~= "", "Reactily className cannot be empty.")

	return host(className, props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a fragment containing multiple elements without adding a Roblox Instance.
--- @param children {element} Child Reactily elements.
--- @param key string? Stable reconciliation key.
--- @return element A fragment element.
function module.createFragment(
	children: {element},
	key: string?
): element
	return {
		children = table.clone(children),
		key = key,
		kind = "fragment",
		props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed Frame element.
--- @param props frameProps? Frame properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A Frame host element.
function module.createFrame(
	props: frameProps?,
	children: {element}?
): element
	return host("Frame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ImageButton element.
--- @param props imageButtonProps? ImageButton properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element An ImageButton host element.
function module.createImageButton(
	props: imageButtonProps?,
	children: {element}?
): element
	return host("ImageButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ImageLabel element.
--- @param props imageLabelProps? ImageLabel properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element An ImageLabel host element.
function module.createImageLabel(
	props: imageLabelProps?,
	children: {element}?
): element
	return host("ImageLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a portal that renders children under another Roblox Instance.
--- @param target Instance Parent that receives the portal's rendered hosts.
--- @param children {element} Child Reactily elements rendered into the target.
--- @param key string? Stable reconciliation key.
--- @return element A portal element.
function module.createPortal(
	target: Instance,
	children: {element},
	key: string?
): element
	return {
		children = table.clone(children),
		key = key,
		kind = "portal",
		props = {},
		target = target,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ScreenGui element.
--- @param props screenGuiProps? ScreenGui properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A ScreenGui host element.
function module.createScreenGui(
	props: screenGuiProps?,
	children: {element}?
): element
	return host("ScreenGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ScrollingFrame element.
--- @param props scrollingFrameProps? ScrollingFrame properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A ScrollingFrame host element.
function module.createScrollingFrame(
	props: scrollingFrameProps?,
	children: {element}?
): element
	return host("ScrollingFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed SurfaceGui element.
--- @param props surfaceGuiProps? SurfaceGui properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A SurfaceGui host element.
function module.createSurfaceGui(
	props: surfaceGuiProps?,
	children: {element}?
): element
	return host("SurfaceGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextBox element.
--- @param props textBoxProps? TextBox properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A TextBox host element.
function module.createTextBox(
	props: textBoxProps?,
	children: {element}?
): element
	return host("TextBox", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextButton element.
--- @param props textButtonProps? TextButton properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A TextButton host element.
function module.createTextButton(
	props: textButtonProps?,
	children: {element}?
): element
	return host("TextButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed TextLabel element.
--- @param props textLabelProps? TextLabel properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A TextLabel host element.
function module.createTextLabel(
	props: textLabelProps?,
	children: {element}?
): element
	return host("TextLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIAspectRatioConstraint element.
--- @param props uiAspectRatioConstraintProps? Constraint properties, metadata, and ref.
--- @return element A UIAspectRatioConstraint host element.
function module.createUIAspectRatioConstraint(
	props: uiAspectRatioConstraintProps?
): element
	return host("UIAspectRatioConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UICorner element.
--- @param props uiCornerProps? UICorner properties, metadata, and ref.
--- @return element A UICorner host element.
function module.createUICorner(props: uiCornerProps?): element
	return host("UICorner", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIGradient element.
--- @param props uiGradientProps? UIGradient properties, metadata, and ref.
--- @return element A UIGradient host element.
function module.createUIGradient(props: uiGradientProps?): element
	return host("UIGradient", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIGridLayout element.
--- @param props uiGridLayoutProps? UIGridLayout properties, metadata, and ref.
--- @return element A UIGridLayout host element.
function module.createUIGridLayout(
	props: uiGridLayoutProps?
): element
	return host("UIGridLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIListLayout element.
--- @param props uiListLayoutProps? UIListLayout properties, metadata, and ref.
--- @return element A UIListLayout host element.
function module.createUIListLayout(
	props: uiListLayoutProps?
): element
	return host("UIListLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIPadding element.
--- @param props uiPaddingProps? UIPadding properties, metadata, and ref.
--- @return element A UIPadding host element.
function module.createUIPadding(props: uiPaddingProps?): element
	return host("UIPadding", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIPageLayout element.
--- @param props uiPageLayoutProps? UIPageLayout properties, metadata, and ref.
--- @return element A UIPageLayout host element.
function module.createUIPageLayout(
	props: uiPageLayoutProps?
): element
	return host("UIPageLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIScale element.
--- @param props uiScaleProps? UIScale properties, metadata, and ref.
--- @return element A UIScale host element.
function module.createUIScale(props: uiScaleProps?): element
	return host("UIScale", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UISizeConstraint element.
--- @param props uiSizeConstraintProps? Constraint properties, metadata, and ref.
--- @return element A UISizeConstraint host element.
function module.createUISizeConstraint(
	props: uiSizeConstraintProps?
): element
	return host("UISizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UIStroke element.
--- @param props uiStrokeProps? UIStroke properties, metadata, and ref.
--- @return element A UIStroke host element.
function module.createUIStroke(props: uiStrokeProps?): element
	return host("UIStroke", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed UITextSizeConstraint element.
--- @param props uiTextSizeConstraintProps? Constraint properties, metadata, and ref.
--- @return element A UITextSizeConstraint host element.
function module.createUITextSizeConstraint(
	props: uiTextSizeConstraintProps?
): element
	return host("UITextSizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed VideoFrame element.
--- @param props videoFrameProps? VideoFrame properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A VideoFrame host element.
function module.createVideoFrame(
	props: videoFrameProps?,
	children: {element}?
): element
	return host("VideoFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a typed ViewportFrame element.
--- @param props viewportFrameProps? ViewportFrame properties, metadata, events, and ref.
--- @param children {element}? Child Reactily elements.
--- @return element A ViewportFrame host element.
function module.createViewportFrame(
	props: viewportFrameProps?,
	children: {element}?
): element
	return host("ViewportFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

return module