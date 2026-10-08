---
title: Reactily.createScrollingFrame
sidebar_label: createScrollingFrame
sidebar_position: 8
description: API reference for Reactily.createScrollingFrame.
---

# `Reactily.createScrollingFrame`

Creates a typed virtual `ScrollingFrame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createScrollingFrame(props: ScrollingFrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ScrollingFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createScrollingFrame({
	Size = UDim2.fromOffset(400, 500),
	CanvasSize = UDim2.fromOffset(0, 1200),
	ScrollBarThickness = 8,
})
```
