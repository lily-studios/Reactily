---
title: "Type: SurfaceGuiProps"
sidebar_label: SurfaceGuiProps
description: Luau type Reactily.SurfaceGuiProps, exported from virtual.element.
api_types: SurfaceGuiProps
---

# `Reactily.SurfaceGuiProps`

`SurfaceGuiProps` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type SurfaceGuiPropsAlias = Reactily.SurfaceGuiProps
```

## Definition

```luau
export type SurfaceGuiProps = HostMetadataProps<SurfaceGui> & {
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
```

## Notes

- Use `Reactily.SurfaceGuiProps` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this type when creating configuration or component-prop tables. It helps the Luau analyzer catch misspelled field names before runtime.

## Notes and common mistakes

- The table must follow the exact field names shown in the definition. Reactily-owned option keys are usually camelCase; only Roblox native Instance properties use their official PascalCase.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
