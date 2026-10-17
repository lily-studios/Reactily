---
title: "Type: ListOptions"
sidebar_label: ListOptions
description: Luau type Reactily.ListOptions, exported from interface.layout.
api_types: ListOptions
---

# `Reactily.ListOptions`

`ListOptions` is a public Luau type exported from the `interface.layout` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ListOptionsAlias = Reactily.ListOptions
```

## Definition

```luau
export type ListOptions = {
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundTransparency: number?,
	FillDirection: Enum.FillDirection?,
	gap: number?,
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
```

## Notes

- Use `Reactily.ListOptions` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
