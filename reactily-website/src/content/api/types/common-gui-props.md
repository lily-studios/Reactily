---
title: "Type: CommonGuiProps"
sidebar_label: CommonGuiProps
description: Luau type Reactily.CommonGuiProps, exported from virtual.element.
api_types: CommonGuiProps
---

# `Reactily.CommonGuiProps`

`CommonGuiProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type CommonGuiPropsAlias<T> = Reactily.CommonGuiProps<T>
```

## Definition

```luau
export type CommonGuiProps<T> = HostMetadataProps<T> & {
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
	onInputBegan: ((input: InputObject) -> ())?,
	onInputChanged: ((input: InputObject) -> ())?,
	onInputEnded: ((input: InputObject) -> ())?,
	onMouseEnter: (() -> ())?,
	onMouseLeave: (() -> ())?,
	onSelectionGained: (() -> ())?,
	onSelectionLost: (() -> ())?,
}
```

## Notes

- Use `Reactily.CommonGuiProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
