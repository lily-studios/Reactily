---
title: Reactily.createSurfaceGui
sidebar_label: createSurfaceGui
sidebar_position: 9
description: API reference for Reactily.createSurfaceGui.
---

# `Reactily.createSurfaceGui`

Creates a typed virtual `SurfaceGui` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createSurfaceGui(props: SurfaceGuiProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `SurfaceGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createSurfaceGui({
	Adornee = panelPart,
	PixelsPerStud = 100,
})
```

## Understanding this API

SurfaceGui displays UI on a 3D surface; use a ScreenGui for normal screen-space interfaces.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the SurfaceGui capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
