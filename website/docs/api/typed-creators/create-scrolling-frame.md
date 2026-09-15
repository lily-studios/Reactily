---
title: Reactily.createScrollingFrame
sidebar_label: createScrollingFrame
sidebar_position: 8
description: API reference for Reactily.createScrollingFrame.
---

# `Reactily.createScrollingFrame`

Creates a typed virtual `ScrollingFrame` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createScrollingFrame(props: scrollingFrameProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `scrollingFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createScrollingFrame({
	size = UDim2.fromOffset(400, 500),
	canvasSize = UDim2.fromOffset(0, 1200),
	scrollBarThickness = 8,
})
```
