---
title: Reactily.createViewportFrame
sidebar_label: createViewportFrame
sidebar_position: 25
description: API reference for Reactily.createViewportFrame.
---

# `Reactily.createViewportFrame`

Creates a typed virtual `ViewportFrame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createViewportFrame(props: ViewportFrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ViewportFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createViewportFrame({
	Size = UDim2.fromOffset(500, 300),
	CurrentCamera = camera,
})
```
