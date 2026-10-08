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

export type hostRefTarget<T> = refCallback<T> | { Current: T? }

export type hostChangeProps = {
	["$Reactily.Change.AbsoluteCanvasSize"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteCellCount"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteCellSize"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteContentSize"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsolutePosition"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteRotation"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteSize"]: ((value: any) -> ())?,
	["$Reactily.Change.AbsoluteWindowSize"]: ((value: any) -> ())?,
	["$Reactily.Change.Active"]: ((value: any) -> ())?,
	["$Reactily.Change.Adornee"]: ((value: any) -> ())?,
	["$Reactily.Change.AlwaysOnTop"]: ((value: any) -> ())?,
	["$Reactily.Change.Ambient"]: ((value: any) -> ())?,
	["$Reactily.Change.AnchorPoint"]: ((value: any) -> ())?,
	["$Reactily.Change.Animated"]: ((value: any) -> ())?,
	["$Reactily.Change.ApplyStrokeMode"]: ((value: any) -> ())?,
	["$Reactily.Change.AspectRatio"]: ((value: any) -> ())?,
	["$Reactily.Change.AspectType"]: ((value: any) -> ())?,
	["$Reactily.Change.AutoButtonColor"]: ((value: any) -> ())?,
	["$Reactily.Change.AutomaticCanvasSize"]: ((value: any) -> ())?,
	["$Reactily.Change.AutomaticSize"]: ((value: any) -> ())?,
	["$Reactily.Change.BackgroundColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.BackgroundTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.BorderColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.BorderMode"]: ((value: any) -> ())?,
	["$Reactily.Change.BorderSizePixel"]: ((value: any) -> ())?,
	["$Reactily.Change.BottomImage"]: ((value: any) -> ())?,
	["$Reactily.Change.Brightness"]: ((value: any) -> ())?,
	["$Reactily.Change.CanvasPosition"]: ((value: any) -> ())?,
	["$Reactily.Change.CanvasSize"]: ((value: any) -> ())?,
	["$Reactily.Change.CellPadding"]: ((value: any) -> ())?,
	["$Reactily.Change.CellSize"]: ((value: any) -> ())?,
	["$Reactily.Change.Circular"]: ((value: any) -> ())?,
	["$Reactily.Change.ClearTextOnFocus"]: ((value: any) -> ())?,
	["$Reactily.Change.ClipsDescendants"]: ((value: any) -> ())?,
	["$Reactily.Change.ClipToDeviceSafeArea"]: ((value: any) -> ())?,
	["$Reactily.Change.Color"]: ((value: any) -> ())?,
	["$Reactily.Change.CornerRadius"]: ((value: any) -> ())?,
	["$Reactily.Change.CurrentCamera"]: ((value: any) -> ())?,
	["$Reactily.Change.CurrentPage"]: ((value: any) -> ())?,
	["$Reactily.Change.CursorPosition"]: ((value: any) -> ())?,
	["$Reactily.Change.DisplayOrder"]: ((value: any) -> ())?,
	["$Reactily.Change.DominantAxis"]: ((value: any) -> ())?,
	["$Reactily.Change.EasingDirection"]: ((value: any) -> ())?,
	["$Reactily.Change.EasingStyle"]: ((value: any) -> ())?,
	["$Reactily.Change.ElasticBehavior"]: ((value: any) -> ())?,
	["$Reactily.Change.Enabled"]: ((value: any) -> ())?,
	["$Reactily.Change.ExtentsOffset"]: ((value: any) -> ())?,
	["$Reactily.Change.ExtentsOffsetWorldSpace"]: ((value: any) -> ())?,
	["$Reactily.Change.Face"]: ((value: any) -> ())?,
	["$Reactily.Change.FillDirection"]: ((value: any) -> ())?,
	["$Reactily.Change.FillDirectionMaxCells"]: ((value: any) -> ())?,
	["$Reactily.Change.Font"]: ((value: any) -> ())?,
	["$Reactily.Change.FontFace"]: ((value: any) -> ())?,
	["$Reactily.Change.GamepadInputEnabled"]: ((value: any) -> ())?,
	["$Reactily.Change.GroupColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.GroupTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.HorizontalAlignment"]: ((value: any) -> ())?,
	["$Reactily.Change.HorizontalFlex"]: ((value: any) -> ())?,
	["$Reactily.Change.HoverImage"]: ((value: any) -> ())?,
	["$Reactily.Change.IgnoreGuiInset"]: ((value: any) -> ())?,
	["$Reactily.Change.Image"]: ((value: any) -> ())?,
	["$Reactily.Change.ImageColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.ImageRectOffset"]: ((value: any) -> ())?,
	["$Reactily.Change.ImageRectSize"]: ((value: any) -> ())?,
	["$Reactily.Change.ImageTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.ItemLineAlignment"]: ((value: any) -> ())?,
	["$Reactily.Change.LayoutOrder"]: ((value: any) -> ())?,
	["$Reactily.Change.LightColor"]: ((value: any) -> ())?,
	["$Reactily.Change.LightDirection"]: ((value: any) -> ())?,
	["$Reactily.Change.LightInfluence"]: ((value: any) -> ())?,
	["$Reactily.Change.LineHeight"]: ((value: any) -> ())?,
	["$Reactily.Change.LineJoinMode"]: ((value: any) -> ())?,
	["$Reactily.Change.Looped"]: ((value: any) -> ())?,
	["$Reactily.Change.MaxDistance"]: ((value: any) -> ())?,
	["$Reactily.Change.MaxSize"]: ((value: any) -> ())?,
	["$Reactily.Change.MaxTextSize"]: ((value: any) -> ())?,
	["$Reactily.Change.MaxVisibleGraphemes"]: ((value: any) -> ())?,
	["$Reactily.Change.MidImage"]: ((value: any) -> ())?,
	["$Reactily.Change.MinSize"]: ((value: any) -> ())?,
	["$Reactily.Change.MinTextSize"]: ((value: any) -> ())?,
	["$Reactily.Change.Modal"]: ((value: any) -> ())?,
	["$Reactily.Change.MultiLine"]: ((value: any) -> ())?,
	["$Reactily.Change.Name"]: ((value: any) -> ())?,
	["$Reactily.Change.NextSelectionDown"]: ((value: any) -> ())?,
	["$Reactily.Change.NextSelectionLeft"]: ((value: any) -> ())?,
	["$Reactily.Change.NextSelectionRight"]: ((value: any) -> ())?,
	["$Reactily.Change.NextSelectionUp"]: ((value: any) -> ())?,
	["$Reactily.Change.Offset"]: ((value: any) -> ())?,
	["$Reactily.Change.Padding"]: ((value: any) -> ())?,
	["$Reactily.Change.PaddingBottom"]: ((value: any) -> ())?,
	["$Reactily.Change.PaddingLeft"]: ((value: any) -> ())?,
	["$Reactily.Change.PaddingRight"]: ((value: any) -> ())?,
	["$Reactily.Change.PaddingTop"]: ((value: any) -> ())?,
	["$Reactily.Change.PixelsPerStud"]: ((value: any) -> ())?,
	["$Reactily.Change.PlaceholderColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.PlaceholderText"]: ((value: any) -> ())?,
	["$Reactily.Change.PlayerToHideFrom"]: ((value: any) -> ())?,
	["$Reactily.Change.Playing"]: ((value: any) -> ())?,
	["$Reactily.Change.Position"]: ((value: any) -> ())?,
	["$Reactily.Change.PressedImage"]: ((value: any) -> ())?,
	["$Reactily.Change.ResampleMode"]: ((value: any) -> ())?,
	["$Reactily.Change.ResetOnSpawn"]: ((value: any) -> ())?,
	["$Reactily.Change.RichText"]: ((value: any) -> ())?,
	["$Reactily.Change.Rotation"]: ((value: any) -> ())?,
	["$Reactily.Change.SafeAreaCompatibility"]: ((value: any) -> ())?,
	["$Reactily.Change.Scale"]: ((value: any) -> ())?,
	["$Reactily.Change.ScaleType"]: ((value: any) -> ())?,
	["$Reactily.Change.ScreenInsets"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollBarImageColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollBarImageTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollBarThickness"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollingDirection"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollingEnabled"]: ((value: any) -> ())?,
	["$Reactily.Change.ScrollWheelInputEnabled"]: ((value: any) -> ())?,
	["$Reactily.Change.Selectable"]: ((value: any) -> ())?,
	["$Reactily.Change.Selected"]: ((value: any) -> ())?,
	["$Reactily.Change.SelectionOrder"]: ((value: any) -> ())?,
	["$Reactily.Change.SelectionStart"]: ((value: any) -> ())?,
	["$Reactily.Change.ShowNativeInput"]: ((value: any) -> ())?,
	["$Reactily.Change.Size"]: ((value: any) -> ())?,
	["$Reactily.Change.SizeConstraint"]: ((value: any) -> ())?,
	["$Reactily.Change.SizeOffset"]: ((value: any) -> ())?,
	["$Reactily.Change.SizingMode"]: ((value: any) -> ())?,
	["$Reactily.Change.SliceCenter"]: ((value: any) -> ())?,
	["$Reactily.Change.SliceScale"]: ((value: any) -> ())?,
	["$Reactily.Change.SortOrder"]: ((value: any) -> ())?,
	["$Reactily.Change.StartCorner"]: ((value: any) -> ())?,
	["$Reactily.Change.StudsOffset"]: ((value: any) -> ())?,
	["$Reactily.Change.StudsOffsetWorldSpace"]: ((value: any) -> ())?,
	["$Reactily.Change.Style"]: ((value: any) -> ())?,
	["$Reactily.Change.Text"]: ((value: any) -> ())?,
	["$Reactily.Change.TextBounds"]: ((value: any) -> ())?,
	["$Reactily.Change.TextColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.TextDirection"]: ((value: any) -> ())?,
	["$Reactily.Change.TextEditable"]: ((value: any) -> ())?,
	["$Reactily.Change.TextFits"]: ((value: any) -> ())?,
	["$Reactily.Change.TextScaled"]: ((value: any) -> ())?,
	["$Reactily.Change.TextSize"]: ((value: any) -> ())?,
	["$Reactily.Change.TextStrokeColor3"]: ((value: any) -> ())?,
	["$Reactily.Change.TextStrokeTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.TextTransparency"]: ((value: any) -> ())?,
	["$Reactily.Change.TextTruncate"]: ((value: any) -> ())?,
	["$Reactily.Change.TextWrapped"]: ((value: any) -> ())?,
	["$Reactily.Change.TextXAlignment"]: ((value: any) -> ())?,
	["$Reactily.Change.TextYAlignment"]: ((value: any) -> ())?,
	["$Reactily.Change.Thickness"]: ((value: any) -> ())?,
	["$Reactily.Change.TileSize"]: ((value: any) -> ())?,
	["$Reactily.Change.TimePosition"]: ((value: any) -> ())?,
	["$Reactily.Change.ToolPunchThroughDistance"]: ((value: any) -> ())?,
	["$Reactily.Change.TopImage"]: ((value: any) -> ())?,
	["$Reactily.Change.TouchInputEnabled"]: ((value: any) -> ())?,
	["$Reactily.Change.Transparency"]: ((value: any) -> ())?,
	["$Reactily.Change.TweenTime"]: ((value: any) -> ())?,
	["$Reactily.Change.VerticalAlignment"]: ((value: any) -> ())?,
	["$Reactily.Change.VerticalFlex"]: ((value: any) -> ())?,
	["$Reactily.Change.VerticalScrollBarInset"]: ((value: any) -> ())?,
	["$Reactily.Change.VerticalScrollBarPosition"]: ((value: any) -> ())?,
	["$Reactily.Change.Video"]: ((value: any) -> ())?,
	["$Reactily.Change.Visible"]: ((value: any) -> ())?,
	["$Reactily.Change.Volume"]: ((value: any) -> ())?,
	["$Reactily.Change.Wraps"]: ((value: any) -> ())?,
	["$Reactily.Change.ZIndex"]: ((value: any) -> ())?,
	["$Reactily.Change.ZIndexBehavior"]: ((value: any) -> ())?,
	["$Reactily.Change.ZOffset"]: ((value: any) -> ())?,
}

export type hostMetadataProps<T> = hostChangeProps & {
	Attributes: attributeMap?,
	Key: string?,
	Name: string?,
	Ref: hostRefTarget<T>?,
	Tags: { string }?,
	OnPropertyChanged: { [string]: (value: any) -> () }?,
	OnAncestryChanged: ((child: Instance, parent: Instance?) -> ())?,
	OnChanged: ((property: string) -> ())?,
}

export type commonGuiProps<T> = hostMetadataProps<T> & {
	Active: boolean?,
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	BorderColor3: Color3?,
	BorderMode: Enum.BorderMode?,
	BorderSizePixel: number?,
	ClipsDescendants: boolean?,
	LayoutOrder: number?,
	NextSelectionDown: GuiObject?,
	NextSelectionLeft: GuiObject?,
	NextSelectionRight: GuiObject?,
	NextSelectionUp: GuiObject?,
	Position: UDim2?,
	Rotation: number?,
	Selectable: boolean?,
	SelectionOrder: number?,
	Size: UDim2?,
	SizeConstraint: Enum.SizeConstraint?,
	Visible: boolean?,
	ZIndex: number?,
	OnInputBegan: ((input: InputObject) -> ())?,
	OnInputChanged: ((input: InputObject) -> ())?,
	OnInputEnded: ((input: InputObject) -> ())?,
	OnMouseEnter: (() -> ())?,
	OnMouseLeave: (() -> ())?,
	OnSelectionGained: (() -> ())?,
	OnSelectionLost: (() -> ())?,
}

export type textProps = {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}

export type imageProps = {
	Image: string?,
	ImageColor3: Color3?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	ImageTransparency: number?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
}

export type buttonEvents = {
	OnActivated: ((input: InputObject, clickCount: number) -> ())?,
	OnMouseButton1Click: (() -> ())?,
	OnMouseButton1Down: ((x: number, y: number) -> ())?,
	OnMouseButton1Up: ((x: number, y: number) -> ())?,
	OnMouseButton2Click: (() -> ())?,
	OnMouseButton2Down: ((x: number, y: number) -> ())?,
	OnMouseButton2Up: ((x: number, y: number) -> ())?,
}

export type billboardGuiProps = hostMetadataProps<BillboardGui> & {
	Active: boolean?,
	Adornee: Instance?,
	AlwaysOnTop: boolean?,
	Brightness: number?,
	ClipsDescendants: boolean?,
	Enabled: boolean?,
	ExtentsOffset: Vector3?,
	ExtentsOffsetWorldSpace: Vector3?,
	LightInfluence: number?,
	MaxDistance: number?,
	PlayerToHideFrom: Player?,
	Size: UDim2?,
	SizeOffset: Vector2?,
	StudsOffset: Vector3?,
	StudsOffsetWorldSpace: Vector3?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
}

export type canvasGroupProps = commonGuiProps<CanvasGroup> & {
	GroupColor3: Color3?,
	GroupTransparency: number?,
}

export type frameProps = commonGuiProps<Frame> & {
	Style: Enum.FrameStyle?,
}

export type imageButtonProps = commonGuiProps<ImageButton> & imageProps & buttonEvents & {
	AutoButtonColor: boolean?,
	HoverImage: string?,
	Modal: boolean?,
	PressedImage: string?,
	Selected: boolean?,
}

export type imageLabelProps = commonGuiProps<ImageLabel> & imageProps

export type screenGuiProps = hostMetadataProps<ScreenGui> & {
	ClipToDeviceSafeArea: boolean?,
	DisplayOrder: number?,
	Enabled: boolean?,
	IgnoreGuiInset: boolean?,
	ResetOnSpawn: boolean?,
	SafeAreaCompatibility: Enum.SafeAreaCompatibility?,
	ScreenInsets: Enum.ScreenInsets?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
}

export type scrollingFrameProps = commonGuiProps<ScrollingFrame> & {
	AutomaticCanvasSize: Enum.AutomaticSize?,
	BottomImage: string?,
	CanvasPosition: Vector2?,
	CanvasSize: UDim2?,
	ElasticBehavior: Enum.ElasticBehavior?,
	MidImage: string?,
	ScrollBarImageColor3: Color3?,
	ScrollBarImageTransparency: number?,
	ScrollBarThickness: number?,
	ScrollingDirection: Enum.ScrollingDirection?,
	ScrollingEnabled: boolean?,
	TopImage: string?,
	VerticalScrollBarInset: Enum.ScrollBarInset?,
	VerticalScrollBarPosition: Enum.VerticalScrollBarPosition?,
}

export type surfaceGuiProps = hostMetadataProps<SurfaceGui> & {
	Active: boolean?,
	Adornee: BasePart?,
	AlwaysOnTop: boolean?,
	Brightness: number?,
	CanvasSize: Vector2?,
	ClipsDescendants: boolean?,
	Enabled: boolean?,
	Face: Enum.NormalId?,
	LightInfluence: number?,
	MaxDistance: number?,
	PixelsPerStud: number?,
	SizingMode: Enum.SurfaceGuiSizingMode?,
	ToolPunchThroughDistance: number?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
	ZOffset: number?,
}

export type textBoxProps = commonGuiProps<TextBox> & textProps & {
	ClearTextOnFocus: boolean?,
	CursorPosition: number?,
	MultiLine: boolean?,
	PlaceholderColor3: Color3?,
	PlaceholderText: string?,
	SelectionStart: number?,
	ShowNativeInput: boolean?,
	TextEditable: boolean?,
	OnFocused: (() -> ())?,
	OnFocusLost: ((enterPressed: boolean, input: InputObject?) -> ())?,
}

export type textButtonProps = commonGuiProps<TextButton> & textProps & buttonEvents & {
	AutoButtonColor: boolean?,
	Modal: boolean?,
	Selected: boolean?,
	Style: Enum.ButtonStyle?,
}

export type textLabelProps = commonGuiProps<TextLabel> & textProps

export type videoFrameProps = commonGuiProps<VideoFrame> & {
	Looped: boolean?,
	Playing: boolean?,
	TimePosition: number?,
	Video: string?,
	Volume: number?,
}

export type viewportFrameProps = commonGuiProps<ViewportFrame> & {
	Ambient: Color3?,
	CurrentCamera: Camera?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	LightColor: Color3?,
	LightDirection: Vector3?,
}

export type uiAspectRatioConstraintProps = hostMetadataProps<UIAspectRatioConstraint> & {
	AspectRatio: number?,
	AspectType: Enum.AspectType?,
	DominantAxis: Enum.DominantAxis?,
}

export type uiCornerProps = hostMetadataProps<UICorner> & {
	CornerRadius: UDim?,
}

export type uiGradientProps = hostMetadataProps<UIGradient> & {
	Color: ColorSequence?,
	Enabled: boolean?,
	Offset: Vector2?,
	Rotation: number?,
	Transparency: NumberSequence?,
}

export type uiGridLayoutProps = hostMetadataProps<UIGridLayout> & {
	CellPadding: UDim2?,
	CellSize: UDim2?,
	FillDirection: Enum.FillDirection?,
	FillDirectionMaxCells: number?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	SortOrder: Enum.SortOrder?,
	StartCorner: Enum.StartCorner?,
	VerticalAlignment: Enum.VerticalAlignment?,
}

export type uiListLayoutProps = hostMetadataProps<UIListLayout> & {
	FillDirection: Enum.FillDirection?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	HorizontalFlex: Enum.UIFlexAlignment?,
	ItemLineAlignment: Enum.ItemLineAlignment?,
	Padding: UDim?,
	SortOrder: Enum.SortOrder?,
	VerticalAlignment: Enum.VerticalAlignment?,
	VerticalFlex: Enum.UIFlexAlignment?,
	Wraps: boolean?,
}

export type uiPaddingProps = hostMetadataProps<UIPadding> & {
	PaddingBottom: UDim?,
	PaddingLeft: UDim?,
	PaddingRight: UDim?,
	PaddingTop: UDim?,
}

export type uiPageLayoutProps = hostMetadataProps<UIPageLayout> & {
	Animated: boolean?,
	Circular: boolean?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	GamepadInputEnabled: boolean?,
	Padding: UDim?,
	ScrollWheelInputEnabled: boolean?,
	TouchInputEnabled: boolean?,
	TweenTime: number?,
}

export type uiScaleProps = hostMetadataProps<UIScale> & {
	Scale: number?,
}

export type uiSizeConstraintProps = hostMetadataProps<UISizeConstraint> & {
	MaxSize: Vector2?,
	MinSize: Vector2?,
}

export type uiStrokeProps = hostMetadataProps<UIStroke> & {
	ApplyStrokeMode: Enum.ApplyStrokeMode?,
	Color: Color3?,
	Enabled: boolean?,
	LineJoinMode: Enum.LineJoinMode?,
	Thickness: number?,
	Transparency: number?,
}

export type uiTextSizeConstraintProps = hostMetadataProps<UITextSizeConstraint> & {
	MaxTextSize: number?,
	MinTextSize: number?,
}

export type genericProps = {
	[string]: any,
}

export type fragmentRefTarget = ((value: any?) -> ()) | { Current: any? }
export type activityMode = "visible" | "hidden"
export type profilerOnRender = (id: string, phase: "mount" | "update", duration: number, reason: string) -> ()
export type viewTransitionConfig = {
	Duration: number?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	EnterFrom: { [string]: any }?,
}

export type element =
	{
		Children: { element },
		ClassName: string,
		Key: string?,
		Kind: "host",
		Props: genericProps,
	}
	| {
		Children: { element },
		component: (props: genericProps) -> element?,
		Key: string?,
		Kind: "component",
		Props: genericProps,
	}
	| {
		Children: { element },
		Key: string?,
		Kind: "fragment",
		Props: genericProps,
		RefTarget: fragmentRefTarget?,
	}
	| {
		Children: { element },
		Key: string?,
		Kind: "portal",
		Props: genericProps,
		target: Instance,
	}
	| {
		Children: { element },
		ContextValue: any,
		Key: string?,
		Kind: "provider",
		Props: genericProps,
		ProvidedValue: any,
	}
	| {
		Children: { element },
		Fallback: element | ((failure: any) -> element),
		Key: string?,
		Kind: "errorBoundary",
		OnError: ((failure: any) -> ())?,
		Props: genericProps,
	}
	| {
		Children: { element },
		Fallback: element,
		Key: string?,
		Kind: "suspense",
		Props: genericProps,
	}
	| {
		Children: { element },
		Key: string?,
		Kind: "activity",
		Mode: activityMode,
		Props: genericProps,
	}
	| {
		Children: { element },
		Id: string,
		Key: string?,
		Kind: "profiler",
		OnRender: profilerOnRender?,
		Props: genericProps,
	}
	| {
		Children: { element },
		Key: string?,
		Kind: "strictMode",
		Props: genericProps,
	}
	| {
		Children: { element },
		Config: viewTransitionConfig?,
		Key: string?,
		Kind: "viewTransition",
		OnEnter: (() -> ())?,
		OnExit: (() -> ())?,
		OnUpdate: (() -> ())?,
		Props: genericProps,
	}

export type component<P> = (props: P) -> element?

export type fragmentMarker = {
	__reactilyFragment: true,
}

local fragmentMarker: fragmentMarker = {
	__reactilyFragment = true,
}

table.freeze(fragmentMarker)

module.Fragment = fragmentMarker

--————————————————————————————————————————————————————————————————————--

local function appendChildren(output: { element }, children: { any })
	for _, child in children do
		if child == nil or child == false then
			continue
		end

		if type(child) == "table" and type(child.Kind) == "string" then
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

	if type(props.Key) ~= "string" then
		return nil
	end

	return props.Key
end

--————————————————————————————————————————————————————————————————————--

local function host(className: string, props: genericProps?, children: { element }?): element
	local genericPropsValue = copyProps(props)
	local key = getKey(genericPropsValue)

	genericPropsValue.Key = nil

	return {
		Children = copyChildren(children),
		ClassName = className,
		Key = key,
		Kind = "host",
		Props = genericPropsValue,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a BillboardGui host element.
--- @param props billboardGuiProps? BillboardGui properties.
--- @param children {element}? Child elements.
--- @return element BillboardGui element.
function module.CreateBillboardGui(props: billboardGuiProps?, children: { element }?): element
	return host("BillboardGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a CanvasGroup host element.
--- @param props canvasGroupProps? CanvasGroup properties.
--- @param children {element}? Child elements.
--- @return element CanvasGroup element.
function module.CreateCanvasGroup(props: canvasGroupProps?, children: { element }?): element
	return host("CanvasGroup", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a function-component element.
--- @param componentValue component<P> Component function.
--- @param props P Component properties.
--- @param children {element}? Child elements exposed to the component element.
--- @param key string? Stable reconciliation key.
--- @return element Component element.
function module.CreateComponent<P>(componentValue: component<P>, props: P, children: { element }?, key: string?): element
	local genericPropsValue = copyProps(props)

	return {
		Children = copyChildren(children),
		component = componentValue :: any,
		Key = key,
		Kind = "component",
		Props = genericPropsValue,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Roblox host, function component, or Fragment element using React-style variadic children.
--- @param elementType string | component<any> | fragmentMarker Roblox class, component function, or Reactily.Fragment.
--- @param props P? Element or component properties.
--- @param ... any Child elements; nested child arrays are flattened by Reactily.
--- @return element Reactily element.
function module.CreateElement<P>(elementType: string | component<P> | fragmentMarker, props: P?, ...: any): element
	local genericPropsValue = copyProps(props)
	local children = { ... }

	if elementType == fragmentMarker then
		local refTarget = genericPropsValue.Ref
		genericPropsValue.Ref = nil
		return module.CreateFragment(children, getKey(genericPropsValue), refTarget)
	end

	if type(elementType) == "function" then
		local key = getKey(genericPropsValue)

		genericPropsValue.Key = nil

		return module.CreateComponent(elementType :: component<any>, genericPropsValue, children :: any, key)
	end

	assert(type(elementType) == "string", "Reactily element type must be a Roblox class, component, or Fragment.")

	assert(elementType ~= "", "Reactily className cannot be empty.")

	return host(elementType, genericPropsValue, children :: any)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a fragment containing normalized child elements.
--- @param children {any} Child elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Fragment element.
function module.CreateFragment(children: { any }, key: string?, refTarget: fragmentRefTarget?): element
	return {
		Children = copyChildren(children),
		Key = key,
		Kind = "fragment",
		Props = {},
		RefTarget = refTarget,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Frame host element.
--- @param props frameProps? Frame properties.
--- @param children {element}? Child elements.
--- @return element Frame element.
function module.CreateFrame(props: frameProps?, children: { element }?): element
	return host("Frame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an ImageButton host element.
--- @param props imageButtonProps? ImageButton properties.
--- @param children {element}? Child elements.
--- @return element ImageButton element.
function module.CreateImageButton(props: imageButtonProps?, children: { element }?): element
	return host("ImageButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates an ImageLabel host element.
--- @param props imageLabelProps? ImageLabel properties.
--- @param children {element}? Child elements.
--- @return element ImageLabel element.
function module.CreateImageLabel(props: imageLabelProps?, children: { element }?): element
	return host("ImageLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a portal that renders children into another Instance.
--- @param target Instance Roblox Instance that receives the portal children.
--- @param children {any} Child elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Portal element.
function module.CreatePortal(target: Instance, children: { any }, key: string?): element
	return {
		Children = copyChildren(children),
		Key = key,
		Kind = "portal",
		Props = {},
		target = target,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ScreenGui host element.
--- @param props screenGuiProps? ScreenGui properties.
--- @param children {element}? Child elements.
--- @return element ScreenGui element.
function module.CreateScreenGui(props: screenGuiProps?, children: { element }?): element
	return host("ScreenGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ScrollingFrame host element.
--- @param props scrollingFrameProps? ScrollingFrame properties.
--- @param children {element}? Child elements.
--- @return element ScrollingFrame element.
function module.CreateScrollingFrame(props: scrollingFrameProps?, children: { element }?): element
	return host("ScrollingFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a SurfaceGui host element.
--- @param props surfaceGuiProps? SurfaceGui properties.
--- @param children {element}? Child elements.
--- @return element SurfaceGui element.
function module.CreateSurfaceGui(props: surfaceGuiProps?, children: { element }?): element
	return host("SurfaceGui", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextBox host element.
--- @param props textBoxProps? TextBox properties.
--- @param children {element}? Child elements.
--- @return element TextBox element.
function module.CreateTextBox(props: textBoxProps?, children: { element }?): element
	return host("TextBox", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextButton host element.
--- @param props textButtonProps? TextButton properties.
--- @param children {element}? Child elements.
--- @return element TextButton element.
function module.CreateTextButton(props: textButtonProps?, children: { element }?): element
	return host("TextButton", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a TextLabel host element.
--- @param props textLabelProps? TextLabel properties.
--- @param children {element}? Child elements.
--- @return element TextLabel element.
function module.CreateTextLabel(props: textLabelProps?, children: { element }?): element
	return host("TextLabel", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIAspectRatioConstraint host element.
--- @param props uiAspectRatioConstraintProps? UIAspectRatioConstraint properties.
--- @return element UIAspectRatioConstraint element.
function module.CreateUIAspectRatioConstraint(props: uiAspectRatioConstraintProps?): element
	return host("UIAspectRatioConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UICorner host element.
--- @param props uiCornerProps? UICorner properties.
--- @return element UICorner element.
function module.CreateUICorner(props: uiCornerProps?): element
	return host("UICorner", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIGradient host element.
--- @param props uiGradientProps? UIGradient properties.
--- @return element UIGradient element.
function module.CreateUIGradient(props: uiGradientProps?): element
	return host("UIGradient", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIGridLayout host element.
--- @param props uiGridLayoutProps? UIGridLayout properties.
--- @return element UIGridLayout element.
function module.CreateUIGridLayout(props: uiGridLayoutProps?): element
	return host("UIGridLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIListLayout host element.
--- @param props uiListLayoutProps? UIListLayout properties.
--- @return element UIListLayout element.
function module.CreateUIListLayout(props: uiListLayoutProps?): element
	return host("UIListLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPadding host element.
--- @param props uiPaddingProps? UIPadding properties.
--- @return element UIPadding element.
function module.CreateUIPadding(props: uiPaddingProps?): element
	return host("UIPadding", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIPageLayout host element.
--- @param props uiPageLayoutProps? UIPageLayout properties.
--- @return element UIPageLayout element.
function module.CreateUIPageLayout(props: uiPageLayoutProps?): element
	return host("UIPageLayout", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIScale host element.
--- @param props uiScaleProps? UIScale properties.
--- @return element UIScale element.
function module.CreateUIScale(props: uiScaleProps?): element
	return host("UIScale", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UISizeConstraint host element.
--- @param props uiSizeConstraintProps? UISizeConstraint properties.
--- @return element UISizeConstraint element.
function module.CreateUISizeConstraint(props: uiSizeConstraintProps?): element
	return host("UISizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UIStroke host element.
--- @param props uiStrokeProps? UIStroke properties.
--- @return element UIStroke element.
function module.CreateUIStroke(props: uiStrokeProps?): element
	return host("UIStroke", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a UITextSizeConstraint host element.
--- @param props uiTextSizeConstraintProps? UITextSizeConstraint properties.
--- @return element UITextSizeConstraint element.
function module.CreateUITextSizeConstraint(props: uiTextSizeConstraintProps?): element
	return host("UITextSizeConstraint", props :: any, nil)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a VideoFrame host element.
--- @param props videoFrameProps? VideoFrame properties.
--- @param children {element}? Child elements.
--- @return element VideoFrame element.
function module.CreateVideoFrame(props: videoFrameProps?, children: { element }?): element
	return host("VideoFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a ViewportFrame host element.
--- @param props viewportFrameProps? ViewportFrame properties.
--- @param children {element}? Child elements.
--- @return element ViewportFrame element.
function module.CreateViewportFrame(props: viewportFrameProps?, children: { element }?): element
	return host("ViewportFrame", props :: any, children)
end

--————————————————————————————————————————————————————————————————————--

--- Creates a provider scope for a Reactily context.
--- @param contextValue any Context returned by Reactily.createContext.
--- @param providedValue any Value visible to descendant components.
--- @param children {any} Descendant elements or nested child arrays.
--- @param key string? Stable reconciliation key.
--- @return element Context-provider element.
function module.CreateContextProvider(contextValue: any, providedValue: any, children: { any }, key: string?): element
	return {
		Children = copyChildren(children),
		ContextValue = contextValue,
		Key = key,
		Kind = "provider",
		Props = {},
		ProvidedValue = providedValue,
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates an error boundary around one child element.
--- @param fallback element | (failure: any) -> element Fallback element or factory.
--- @param child element Child subtree protected by the boundary.
--- @param onError ((failure: any) -> ())? Optional error callback.
--- @param key string? Stable reconciliation key.
--- @return element Error-boundary element.
function module.CreateErrorBoundary(
	fallback: element | ((failure: any) -> element),
	child: element,
	onError: ((failure: any) -> ())?,
	key: string?
): element
	return {
		Children = { child },
		Fallback = fallback,
		Key = key,
		Kind = "errorBoundary",
		OnError = onError,
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Suspense boundary around one child element.
--- @param fallback element Fallback rendered while a descendant resource is pending.
--- @param child element Child subtree that may suspend.
--- @param key string? Stable reconciliation key.
--- @return element Suspense element.
function module.CreateSuspense(fallback: element, child: element, key: string?): element
	return {
		Children = { child },
		Fallback = fallback,
		Key = key,
		Kind = "suspense",
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates an Activity boundary that can hide UI while preserving subtree state.
--- @reactilyExport
function module.CreateActivity(mode: activityMode, children: { any }, key: string?): element
	assert(mode == "visible" or mode == "hidden", "Reactily Activity mode must be visible or hidden.")
	return {
		Children = copyChildren(children),
		Key = key,
		Kind = "activity",
		Mode = mode,
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a programmatic profiler boundary around one child.
--- @reactilyExport
function module.CreateProfiler(id: string, child: element, onRender: profilerOnRender?, key: string?): element
	assert(id ~= "", "Reactily Profiler id must not be empty.")
	return {
		Children = { child },
		Id = id,
		Key = key,
		Kind = "profiler",
		OnRender = onRender,
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a StrictMode development boundary.
--- @reactilyExport
function module.CreateStrictMode(children: { any }, key: string?): element
	return {
		Children = copyChildren(children),
		Key = key,
		Kind = "strictMode",
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- Creates a Roblox-native ViewTransition boundary around one child.
--- @reactilyExport
function module.CreateViewTransition(
	child: element,
	config: viewTransitionConfig?,
	onEnter: (() -> ())?,
	onExit: (() -> ())?,
	onUpdate: (() -> ())?,
	key: string?
): element
	return {
		Children = { child },
		Config = config,
		Key = key,
		Kind = "viewTransition",
		OnEnter = onEnter,
		OnExit = onExit,
		OnUpdate = onUpdate,
		Props = {},
	}
end

--————————————————————————————————————————————————————————————————————--

--- @reactilyExport
--- Returns a shallow clone of an element with merged props and optional replacement children.
--- @param elementValue element Element to clone.
--- @param props genericProps? Props to merge over the existing props.
--- @param children {any}? Replacement children. Existing children are preserved when omitted.
--- @return element Cloned Reactily element.
function module.CloneElement(elementValue: element, props: genericProps?, children: { any }?): element
	local output: any = table.clone(elementValue :: any)
	local nextProps = table.clone(elementValue.Props)
	local nextKey = elementValue.Key

	if props then
		local providedKey = getKey(props)

		if providedKey then
			nextKey = providedKey
		end

		for propName, value in props do
			if propName == "Key" then
				continue
			end

			nextProps[propName] = value
		end
	end

	nextProps.Key = nil

	output.Key = nextKey
	output.Props = nextProps

	if children then
		output.Children = copyChildren(children)
	end

	return output :: element
end

--————————————————————————————————————————————————————————————————————--

--- @reactilyExport
--- Returns whether a value is a Reactily element.
--- @param value any Value to inspect.
--- @return boolean True when the value has a valid Reactily element kind.
function module.IsValidElement(value: any): boolean
	if type(value) ~= "table" then
		return false
	end

	local kind = value.Kind

	return kind == "host"
		or kind == "component"
		or kind == "fragment"
		or kind == "portal"
		or kind == "provider"
		or kind == "errorBoundary"
		or kind == "suspense"
		or kind == "activity"
		or kind == "profiler"
		or kind == "strictMode"
		or kind == "viewTransition"
end

--————————————————————————————————————————————————————————————————————--

--- Flattens nested Reactily child arrays and removes false/nil entries.
--- @param children {any} Child values to normalize.
--- @return {element} Flat ordered element array.
function module.FlattenChildren(children: { any }): { element }
	return copyChildren(children)
end

--————————————————————————————————————————————————————————————————————--

--- Returns a shallow element clone with a replacement reconciliation key.
--- @param elementValue element Element to clone.
--- @param key string Stable key.
--- @return element Keyed element clone.
function module.Key(elementValue: element, key: string): element
	assert(key ~= "", "Reactily element key cannot be empty.")

	local output: any = table.clone(elementValue :: any)

	output.Key = key

	return output
end

--————————————————————————————————————————————————————————————————————--

return module
