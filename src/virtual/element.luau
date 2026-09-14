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

export type attributeMap = { [string]: attributeValue }

export type refCallback<T> = (instance: T?) -> ()

export type hostMetadataProps<T> = {
	attributes: attributeMap?,
	key: string?,
	name: string?,
	ref: refCallback<T>?,
	tags: { string }?,
	onPropertyChanged: { [string]: (value: any) -> () }?,
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
		children: { element },
		className: string,
		key: string?,
		kind: "host",
		props: genericProps,
	}
	| {
		children: { element },
		component: (props: genericProps) -> element?,
		key: string?,
		kind: "component",
		props: genericProps,
	}
	| {
		children: { element },
		key: string?,
		kind: "fragment",
		props: genericProps,
	}
	| {
		children: { element },
		key: string?,
		kind: "portal",
		props: genericProps,
		target: Instance,
	}
	| {
		children: { element },
		contextValue: any,
		key: string?,
		kind: "provider",
		props: genericProps,
		providedValue: any,
	}
	| {
		children: { element },
		fallback: element | ((failure: any) -> element),
		key: string?,
		kind: "errorBoundary",
		onError: ((failure: any) -> ())?,
		props: genericProps,
	}
	| {
		children: { element },
		fallback: element,
		key: string?,
		kind: "suspense",
		props: genericProps,
	}

export type component<P> = (props: P) -> element?

--————————————————————————————————————————————————————————————————————--

local function appendChildren(output: { element }, children: { any })
	for _, child in children do
		if child == nil or child == false then
			continue
		end

		if type(child) == "table" and type(child.kind) == "string" then
			output[#output + 1] = child :: element
			continue
		end

		if type(child) == "table" then
			appendChildren(output, child)
			continue
		end

		error(`Reactily child must be an element, nested child array, false, or nil; received {typeof(child)}.`, 3)
	end
end

--————————————————————————————————————————————————————————————————————--

local function copyChildren(children: { any }?): { element }
	if not children then
		return {}
	end

	local output: { element } = {}
	appendChildren(output, children)

	return output
end

--————————————————————————————————————————————————————————————————————--

local function copyProps<T>(props: T?): genericProps
	if not props then
		return {}
	end

	return table.clone(props :: any)
end

--————————————————————————————————————————————————————————————————————--

local function getKey(props: genericProps?): string?
	if not props then
		return nil
	end
	if type(props.key) ~= "string" then
		return nil
	end

	return props.key
end

--————————————————————————————————————————————————————————————————————--

local function host(className: string, props: genericProps?, children: { element }?): element
	return {
		children = copyChildren(children),
		className = className,
		key = getKey(props),
		kind = "host",
		props = copyProps(props),
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a BillboardGui host element.
--- @param props billboardGuiProps? BillboardGui properties.
--- @param children {element}? Child elements.
--- @return element BillboardGui element.
function module.createBillboardGui(props: billboardGuiProps?, children: { element }?): element
	return host("BillboardGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a CanvasGroup host element.
--- @param props canvasGroupProps? CanvasGroup properties.
--- @param children {element}? Child elements.
--- @return element CanvasGroup element.
function module.createCanvasGroup(props: canvasGroupProps?, children: { element }?): element
	return host("CanvasGroup", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a function-component element.
--- @param componentValue component<P> Component function.
--- @param props P Component properties.
--- @param children {element}? Child elements exposed to the component element.
--- @param key string? Stable reconciliation key.
--- @return element Component element.
function module.createComponent<P>(componentValue: component<P>, props: P, children: { element }?, key: string?): element
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

--- Creates a host element for an arbitrary Roblox class.
--- @param className string Roblox class name.
--- @param props genericProps? Host properties.
--- @param children {element}? Child elements.
--- @return element Host element.
function module.createElement(className: string, props: genericProps?, children: { element }?): element
	assert(className ~= "", "Reactily className cannot be empty.")

	return host(className, props, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a fragment containing normalized child elements.
--- @param children {any} Child elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Fragment element.
function module.createFragment(children: { any }, key: string?): element
	return {
		children = copyChildren(children),
		key = key,
		kind = "fragment",
		props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Frame host element.
--- @param props frameProps? Frame properties.
--- @param children {element}? Child elements.
--- @return element Frame element.
function module.createFrame(props: frameProps?, children: { element }?): element
	return host("Frame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an ImageButton host element.
--- @param props imageButtonProps? ImageButton properties.
--- @param children {element}? Child elements.
--- @return element ImageButton element.
function module.createImageButton(props: imageButtonProps?, children: { element }?): element
	return host("ImageButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an ImageLabel host element.
--- @param props imageLabelProps? ImageLabel properties.
--- @param children {element}? Child elements.
--- @return element ImageLabel element.
function module.createImageLabel(props: imageLabelProps?, children: { element }?): element
	return host("ImageLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a portal that renders children into another Instance.
--- @param target Instance Roblox Instance that receives the portal children.
--- @param children {any} Child elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Portal element.
function module.createPortal(target: Instance, children: { any }, key: string?): element
	return {
		children = copyChildren(children),
		key = key,
		kind = "portal",
		props = {},
		target = target,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ScreenGui host element.
--- @param props screenGuiProps? ScreenGui properties.
--- @param children {element}? Child elements.
--- @return element ScreenGui element.
function module.createScreenGui(props: screenGuiProps?, children: { element }?): element
	return host("ScreenGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ScrollingFrame host element.
--- @param props scrollingFrameProps? ScrollingFrame properties.
--- @param children {element}? Child elements.
--- @return element ScrollingFrame element.
function module.createScrollingFrame(props: scrollingFrameProps?, children: { element }?): element
	return host("ScrollingFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a SurfaceGui host element.
--- @param props surfaceGuiProps? SurfaceGui properties.
--- @param children {element}? Child elements.
--- @return element SurfaceGui element.
function module.createSurfaceGui(props: surfaceGuiProps?, children: { element }?): element
	return host("SurfaceGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextBox host element.
--- @param props textBoxProps? TextBox properties.
--- @param children {element}? Child elements.
--- @return element TextBox element.
function module.createTextBox(props: textBoxProps?, children: { element }?): element
	return host("TextBox", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextButton host element.
--- @param props textButtonProps? TextButton properties.
--- @param children {element}? Child elements.
--- @return element TextButton element.
function module.createTextButton(props: textButtonProps?, children: { element }?): element
	return host("TextButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextLabel host element.
--- @param props textLabelProps? TextLabel properties.
--- @param children {element}? Child elements.
--- @return element TextLabel element.
function module.createTextLabel(props: textLabelProps?, children: { element }?): element
	return host("TextLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIAspectRatioConstraint host element.
--- @param props uiAspectRatioConstraintProps? UIAspectRatioConstraint properties.
--- @return element UIAspectRatioConstraint element.
function module.createUIAspectRatioConstraint(props: uiAspectRatioConstraintProps?): element
	return host("UIAspectRatioConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UICorner host element.
--- @param props uiCornerProps? UICorner properties.
--- @return element UICorner element.
function module.createUICorner(props: uiCornerProps?): element
	return host("UICorner", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIGradient host element.
--- @param props uiGradientProps? UIGradient properties.
--- @return element UIGradient element.
function module.createUIGradient(props: uiGradientProps?): element
	return host("UIGradient", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIGridLayout host element.
--- @param props uiGridLayoutProps? UIGridLayout properties.
--- @return element UIGridLayout element.
function module.createUIGridLayout(props: uiGridLayoutProps?): element
	return host("UIGridLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIListLayout host element.
--- @param props uiListLayoutProps? UIListLayout properties.
--- @return element UIListLayout element.
function module.createUIListLayout(props: uiListLayoutProps?): element
	return host("UIListLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPadding host element.
--- @param props uiPaddingProps? UIPadding properties.
--- @return element UIPadding element.
function module.createUIPadding(props: uiPaddingProps?): element
	return host("UIPadding", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPageLayout host element.
--- @param props uiPageLayoutProps? UIPageLayout properties.
--- @return element UIPageLayout element.
function module.createUIPageLayout(props: uiPageLayoutProps?): element
	return host("UIPageLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIScale host element.
--- @param props uiScaleProps? UIScale properties.
--- @return element UIScale element.
function module.createUIScale(props: uiScaleProps?): element
	return host("UIScale", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UISizeConstraint host element.
--- @param props uiSizeConstraintProps? UISizeConstraint properties.
--- @return element UISizeConstraint element.
function module.createUISizeConstraint(props: uiSizeConstraintProps?): element
	return host("UISizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIStroke host element.
--- @param props uiStrokeProps? UIStroke properties.
--- @return element UIStroke element.
function module.createUIStroke(props: uiStrokeProps?): element
	return host("UIStroke", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UITextSizeConstraint host element.
--- @param props uiTextSizeConstraintProps? UITextSizeConstraint properties.
--- @return element UITextSizeConstraint element.
function module.createUITextSizeConstraint(props: uiTextSizeConstraintProps?): element
	return host("UITextSizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a VideoFrame host element.
--- @param props videoFrameProps? VideoFrame properties.
--- @param children {element}? Child elements.
--- @return element VideoFrame element.
function module.createVideoFrame(props: videoFrameProps?, children: { element }?): element
	return host("VideoFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ViewportFrame host element.
--- @param props viewportFrameProps? ViewportFrame properties.
--- @param children {element}? Child elements.
--- @return element ViewportFrame element.
function module.createViewportFrame(props: viewportFrameProps?, children: { element }?): element
	return host("ViewportFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a provider scope for a Reactily context.
--- @param contextValue any Context returned by Reactily.createContext.
--- @param providedValue any Value visible to descendant components.
--- @param children {any} Descendant elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Context-provider element.
function module.createContextProvider(contextValue: any, providedValue: any, children: { any }, key: string?): element
	return {
		children = copyChildren(children),
		contextValue = contextValue,
		key = key,
		kind = "provider",
		props = {},
		providedValue = providedValue,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates an error boundary around one child element.
--- @param fallback element | (failure: any) -> element Fallback element or factory.
--- @param child element Child subtree protected by the boundary.
--- @param onError ((failure: any) -> ())? Optional error callback.
--- @param key string? Stable reconciliation key.
--- @return element Error-boundary element.
function module.createErrorBoundary(
	fallback: element | ((failure: any) -> element),
	child: element,
	onError: ((failure: any) -> ())?,
	key: string?
): element
	return {
		children = { child },
		fallback = fallback,
		key = key,
		kind = "errorBoundary",
		onError = onError,
		props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Suspense boundary around one child element.
--- @param fallback element Fallback rendered while a descendant resource is pending.
--- @param child element Child subtree that may suspend.
--- @param key string? Stable reconciliation key.
--- @return element Suspense element.
function module.createSuspense(fallback: element, child: element, key: string?): element
	return {
		children = { child },
		fallback = fallback,
		key = key,
		kind = "suspense",
		props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Flattens nested Reactily child arrays and removes false/nil entries.
--- @param children {any} Child values to normalize.
--- @return {element} Flat ordered element array.
function module.flattenChildren(children: { any }): { element }
	return copyChildren(children)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a shallow element clone with a replacement reconciliation key.
--- @param elementValue element Element to clone.
--- @param key string Stable key.
--- @return element Keyed element clone.
function module.key(elementValue: element, key: string): element
	assert(key ~= "", "Reactily element key cannot be empty.")

	local output: any = table.clone(elementValue :: any)
	output.key = key

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
