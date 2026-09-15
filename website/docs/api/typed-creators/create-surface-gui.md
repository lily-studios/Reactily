---
title: Reactily.createSurfaceGui
sidebar_label: createSurfaceGui
sidebar_position: 9
description: API reference for Reactily.createSurfaceGui.
---

# `Reactily.createSurfaceGui`

Creates a typed virtual `SurfaceGui` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createSurfaceGui(props: surfaceGuiProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `surfaceGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createSurfaceGui({
	adornee = panelPart,
	pixelsPerStud = 100,
})
```
