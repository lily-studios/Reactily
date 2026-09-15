---
title: Reactily.createFrame
sidebar_label: createFrame
sidebar_position: 4
description: API reference for Reactily.createFrame.
---

# `Reactily.createFrame`

Creates a typed virtual `Frame` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createFrame(props: frameProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `frameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createFrame({
	size = UDim2.fromOffset(400, 240),
	backgroundColor3 = Color3.fromRGB(30, 30, 34),
	borderSizePixel = 0,
})
```
