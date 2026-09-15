---
title: Reactily.applyStyle
sidebar_label: applyStyle
sidebar_position: 2
description: API reference for Reactily.applyStyle.
---

# `Reactily.applyStyle`

Applies a style table onto a cloned typed props table.

## Signature
```typescript
Reactily.applyStyle<T>(properties: T, styleValue: style): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `properties` | `T` | Yes | Typed props table that receives the supplied Reactily style values. |
| `styleValue` | `style` | Yes | Reactily style table to apply. |

## Returns

`T`.

## Usage
```typescript
local props = Reactily.applyStyle({
	size = UDim2.fromOffset(200, 80),
}, {
	backgroundTransparency = .2,
})
```
