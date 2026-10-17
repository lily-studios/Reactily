---
title: "Type: ChangeKeys"
sidebar_label: ChangeKeys
description: Luau type Reactily.ChangeKeys, exported from runtime.hostConfig.
api_types: ChangeKeys
---

# `Reactily.ChangeKeys`

`ChangeKeys` is a public Luau type exported from the `runtime.hostConfig` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ChangeKeysAlias = Reactily.ChangeKeys
```

## Definition

```luau
export type ChangeKeys = {
	AbsoluteCanvasSize: "$Reactily.Change.AbsoluteCanvasSize",
	AbsoluteCellCount: "$Reactily.Change.AbsoluteCellCount",
	AbsoluteCellSize: "$Reactily.Change.AbsoluteCellSize",
	AbsoluteContentSize: "$Reactily.Change.AbsoluteContentSize",
	AbsolutePosition: "$Reactily.Change.AbsolutePosition",
	AbsoluteRotation: "$Reactily.Change.AbsoluteRotation",
	AbsoluteSize: "$Reactily.Change.AbsoluteSize",
	AbsoluteWindowSize: "$Reactily.Change.AbsoluteWindowSize",
	Active: "$Reactily.Change.Active",
	Adornee: "$Reactily.Change.Adornee",
	AlwaysOnTop: "$Reactily.Change.AlwaysOnTop",
	Ambient: "$Reactily.Change.Ambient",
	AnchorPoint: "$Reactily.Change.AnchorPoint",
	Animated: "$Reactily.Change.Animated",
	ApplyStrokeMode: "$Reactily.Change.ApplyStrokeMode",
	AspectRatio: "$Reactily.Change.AspectRatio",
	AspectType: "$Reactily.Change.AspectType",
	AutoButtonColor: "$Reactily.Change.AutoButtonColor",
	AutomaticCanvasSize: "$Reactily.Change.AutomaticCanvasSize",
	AutomaticSize: "$Reactily.Change.AutomaticSize",
	BackgroundColor3: "$Reactily.Change.BackgroundColor3",
	BackgroundTransparency: "$Reactily.Change.BackgroundTransparency",
	BorderColor3: "$Reactily.Change.BorderColor3",
	BorderMode: "$Reactily.Change.BorderMode",
	BorderSizePixel: "$Reactily.Change.BorderSizePixel",
	BottomImage: "$Reactily.Change.BottomImage",
	Brightness: "$Reactily.Change.Brightness",
	CanvasPosition: "$Reactily.Change.CanvasPosition",
	CanvasSize: "$Reactily.Change.CanvasSize",
	CellPadding: "$Reactily.Change.CellPadding",
	CellSize: "$Reactily.Change.CellSize",
	Circular: "$Reactily.Change.Circular",
	ClearTextOnFocus: "$Reactily.Change.ClearTextOnFocus",
	ClipsDescendants: "$Reactily.Change.ClipsDescendants",
	ClipToDeviceSafeArea: "$Reactily.Change.ClipToDeviceSafeArea",
	Color: "$Reactily.Change.Color",
	CornerRadius: "$Reactily.Change.CornerRadius",
	CurrentCamera: "$Reactily.Change.CurrentCamera",
	CurrentPage: "$Reactily.Change.CurrentPage",
	CursorPosition: "$Reactily.Change.CursorPosition",
	DisplayOrder: "$Reactily.Change.DisplayOrder",
	DominantAxis: "$Reactily.Change.DominantAxis",
	EasingDirection: "$Reactily.Change.EasingDirection",
	EasingStyle: "$Reactily.Change.EasingStyle",
	ElasticBehavior: "$Reactily.Change.ElasticBehavior",
	Enabled: "$Reactily.Change.Enabled",
	ExtentsOffset: "$Reactily.Change.ExtentsOffset",
	ExtentsOffsetWorldSpace: "$Reactily.Change.ExtentsOffsetWorldSpace",
	Face: "$Reactily.Change.Face",
	FillDirection: "$Reactily.Change.FillDirection",
	FillDirectionMaxCells: "$Reactily.Change.FillDirectionMaxCells",
	Font: "$Reactily.Change.Font",
	FontFace: "$Reactily.Change.FontFace",
	GamepadInputEnabled: "$Reactily.Change.GamepadInputEnabled",
	GroupColor3: "$Reactily.Change.GroupColor3",
	GroupTransparency: "$Reactily.Change.GroupTransparency",
	HorizontalAlignment: "$Reactily.Change.HorizontalAlignment",
	HorizontalFlex: "$Reactily.Change.HorizontalFlex",
	HoverImage: "$Reactily.Change.HoverImage",
	IgnoreGuiInset: "$Reactily.Change.IgnoreGuiInset",
	Image: "$Reactily.Change.Image",
```

## Notes

- Use `Reactily.ChangeKeys` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
