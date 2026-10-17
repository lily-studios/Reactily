---
title: "Type: BillboardGuiProps"
sidebar_label: BillboardGuiProps
description: Luau type Reactily.BillboardGuiProps, exported from virtual.element.
api_types: BillboardGuiProps
---

# `Reactily.BillboardGuiProps`

`BillboardGuiProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type BillboardGuiPropsAlias = Reactily.BillboardGuiProps
```

## Definition

```luau
export type BillboardGuiProps = HostMetadataProps<BillboardGui> & {
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
```

## Notes

- Use `Reactily.BillboardGuiProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
