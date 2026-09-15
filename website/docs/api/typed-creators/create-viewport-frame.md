---
title: Reactily.createViewportFrame
sidebar_label: createViewportFrame
sidebar_position: 25
description: API reference for Reactily.createViewportFrame.
---

# `Reactily.createViewportFrame`

Creates a typed virtual `ViewportFrame` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createViewportFrame(props: viewportFrameProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `viewportFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createViewportFrame({
	size = UDim2.fromOffset(500, 300),
	currentCamera = camera,
})
```
