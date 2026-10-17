---
title: "Type: CommonOptions"
sidebar_label: CommonOptions
description: Luau type Reactily.CommonOptions, exported from interface.layout.
api_types: CommonOptions
---

# `Reactily.CommonOptions`

`CommonOptions` is a public Luau type exported from the `interface.layout` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type CommonOptionsAlias = Reactily.CommonOptions
```

## Definition

```luau
export type CommonOptions = {
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
```

## Notes

- Use `Reactily.CommonOptions` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
