---
title: "Type: ScrollingFrameProps"
sidebar_label: ScrollingFrameProps
description: Luau type Reactily.ScrollingFrameProps, exported from virtual.element.
api_types: ScrollingFrameProps
---

# `Reactily.ScrollingFrameProps`

`ScrollingFrameProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ScrollingFramePropsAlias = Reactily.ScrollingFrameProps
```

## Definition

```luau
export type ScrollingFrameProps = CommonGuiProps<ScrollingFrame> & {
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
```

## Notes

- Use `Reactily.ScrollingFrameProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
