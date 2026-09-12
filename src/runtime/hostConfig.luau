--!strict

-- maps Reactily host prop names to Roblox properties and signals

--————————————————————————————————————————————————————————————————————--

local module = {}

--————————————————————————————————————————————————————————————————————--

local eventNames: {[string]: string} = {
	onActivated = "Activated",
	onAncestryChanged = "AncestryChanged",
	onChanged = "Changed",
	onFocused = "Focused",
	onFocusLost = "FocusLost",
	onInputBegan = "InputBegan",
	onInputChanged = "InputChanged",
	onInputEnded = "InputEnded",
	onMouseButton1Click = "MouseButton1Click",
	onMouseButton1Down = "MouseButton1Down",
	onMouseButton1Up = "MouseButton1Up",
	onMouseButton2Click = "MouseButton2Click",
	onMouseButton2Down = "MouseButton2Down",
	onMouseButton2Up = "MouseButton2Up",
	onMouseEnter = "MouseEnter",
	onMouseLeave = "MouseLeave",
	onSelectionGained = "SelectionGained",
	onSelectionLost = "SelectionLost",
}

local propertyNames: {[string]: string} = {
	active = "Active",
	adornee = "Adornee",
	alwaysOnTop = "AlwaysOnTop",
	ambient = "Ambient",
	anchorPoint = "AnchorPoint",
	animated = "Animated",
	applyStrokeMode = "ApplyStrokeMode",
	aspectRatio = "AspectRatio",
	aspectType = "AspectType",
	autoButtonColor = "AutoButtonColor",
	automaticCanvasSize = "AutomaticCanvasSize",
	automaticSize = "AutomaticSize",
	backgroundColor3 = "BackgroundColor3",
	backgroundTransparency = "BackgroundTransparency",
	borderColor3 = "BorderColor3",
	borderMode = "BorderMode",
	borderSizePixel = "BorderSizePixel",
	bottomImage = "BottomImage",
	brightness = "Brightness",
	canvasPosition = "CanvasPosition",
	canvasSize = "CanvasSize",
	cellPadding = "CellPadding",
	cellSize = "CellSize",
	circular = "Circular",
	clearTextOnFocus = "ClearTextOnFocus",
	clipToDeviceSafeArea = "ClipToDeviceSafeArea",
	clipsDescendants = "ClipsDescendants",
	color = "Color",
	cornerRadius = "CornerRadius",
	currentCamera = "CurrentCamera",
	cursorPosition = "CursorPosition",
	displayOrder = "DisplayOrder",
	dominantAxis = "DominantAxis",
	easingDirection = "EasingDirection",
	easingStyle = "EasingStyle",
	elasticBehavior = "ElasticBehavior",
	enabled = "Enabled",
	extentsOffset = "ExtentsOffset",
	extentsOffsetWorldSpace = "ExtentsOffsetWorldSpace",
	face = "Face",
	fillDirection = "FillDirection",
	fillDirectionMaxCells = "FillDirectionMaxCells",
	font = "Font",
	fontFace = "FontFace",
	gamepadInputEnabled = "GamepadInputEnabled",
	groupColor3 = "GroupColor3",
	groupTransparency = "GroupTransparency",
	horizontalAlignment = "HorizontalAlignment",
	horizontalFlex = "HorizontalFlex",
	hoverImage = "HoverImage",
	ignoreGuiInset = "IgnoreGuiInset",
	image = "Image",
	imageColor3 = "ImageColor3",
	imageRectOffset = "ImageRectOffset",
	imageRectSize = "ImageRectSize",
	imageTransparency = "ImageTransparency",
	itemLineAlignment = "ItemLineAlignment",
	layoutOrder = "LayoutOrder",
	lightColor = "LightColor",
	lightDirection = "LightDirection",
	lightInfluence = "LightInfluence",
	lineHeight = "LineHeight",
	lineJoinMode = "LineJoinMode",
	looped = "Looped",
	maxDistance = "MaxDistance",
	maximumSize = "MaxSize",
	maximumTextSize = "MaxTextSize",
	maxVisibleGraphemes = "MaxVisibleGraphemes",
	midImage = "MidImage",
	minimumSize = "MinSize",
	minimumTextSize = "MinTextSize",
	modal = "Modal",
	multiLine = "MultiLine",
	name = "Name",
	nextSelectionDown = "NextSelectionDown",
	nextSelectionLeft = "NextSelectionLeft",
	nextSelectionRight = "NextSelectionRight",
	nextSelectionUp = "NextSelectionUp",
	offset = "Offset",
	padding = "Padding",
	paddingBottom = "PaddingBottom",
	paddingLeft = "PaddingLeft",
	paddingRight = "PaddingRight",
	paddingTop = "PaddingTop",
	pixelsPerStud = "PixelsPerStud",
	placeholderColor3 = "PlaceholderColor3",
	placeholderText = "PlaceholderText",
	playing = "Playing",
	playerToHideFrom = "PlayerToHideFrom",
	position = "Position",
	pressedImage = "PressedImage",
	resampleMode = "ResampleMode",
	resetOnSpawn = "ResetOnSpawn",
	richText = "RichText",
	rotation = "Rotation",
	safeAreaCompatibility = "SafeAreaCompatibility",
	scale = "Scale",
	scaleType = "ScaleType",
	screenInsets = "ScreenInsets",
	scrollBarImageColor3 = "ScrollBarImageColor3",
	scrollBarImageTransparency = "ScrollBarImageTransparency",
	scrollBarThickness = "ScrollBarThickness",
	scrollingDirection = "ScrollingDirection",
	scrollingEnabled = "ScrollingEnabled",
	scrollWheelInputEnabled = "ScrollWheelInputEnabled",
	selectable = "Selectable",
	selected = "Selected",
	selectionOrder = "SelectionOrder",
	selectionStart = "SelectionStart",
	showNativeInput = "ShowNativeInput",
	size = "Size",
	sizeConstraint = "SizeConstraint",
	sizeOffset = "SizeOffset",
	sizingMode = "SizingMode",
	sliceCenter = "SliceCenter",
	sliceScale = "SliceScale",
	sortOrder = "SortOrder",
	startCorner = "StartCorner",
	studsOffset = "StudsOffset",
	studsOffsetWorldSpace = "StudsOffsetWorldSpace",
	style = "Style",
	text = "Text",
	textColor3 = "TextColor3",
	textDirection = "TextDirection",
	textEditable = "TextEditable",
	textScaled = "TextScaled",
	textSize = "TextSize",
	textStrokeColor3 = "TextStrokeColor3",
	textStrokeTransparency = "TextStrokeTransparency",
	textTransparency = "TextTransparency",
	textTruncate = "TextTruncate",
	textWrapped = "TextWrapped",
	textXAlignment = "TextXAlignment",
	textYAlignment = "TextYAlignment",
	thickness = "Thickness",
	tileSize = "TileSize",
	timePosition = "TimePosition",
	toolPunchThroughDistance = "ToolPunchThroughDistance",
	topImage = "TopImage",
	touchInputEnabled = "TouchInputEnabled",
	transparency = "Transparency",
	tweenTime = "TweenTime",
	verticalAlignment = "VerticalAlignment",
	verticalFlex = "VerticalFlex",
	verticalScrollBarInset = "VerticalScrollBarInset",
	verticalScrollBarPosition = "VerticalScrollBarPosition",
	video = "Video",
	visible = "Visible",
	volume = "Volume",
	wraps = "Wraps",
	zIndex = "ZIndex",
	zIndexBehavior = "ZIndexBehavior",
	zOffset = "ZOffset",
}

--————————————————————————————————————————————————————————————————————--

function module.getEventName(propName: string): string?
	return eventNames[propName]
end

--————————————————————————————————————————————————————————————————————--

function module.getPropertyName(propName: string): string?
	return propertyNames[propName]
end

--————————————————————————————————————————————————————————————————————--

function module.isEvent(propName: string): boolean
	return eventNames[propName] ~= nil
end

--————————————————————————————————————————————————————————————————————--

function module.isProperty(propName: string): boolean
	return propertyNames[propName] ~= nil
end

--————————————————————————————————————————————————————————————————————--

return module
