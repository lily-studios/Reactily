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
