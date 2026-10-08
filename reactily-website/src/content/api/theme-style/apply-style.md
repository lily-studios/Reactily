---
title: Reactily.applyStyle
sidebar_label: applyStyle
sidebar_position: 2
description: API reference for Reactily.applyStyle.
---

# `Reactily.applyStyle`

Applies a style table onto a cloned typed props table.

## Signature
```luau
Reactily.applyStyle<T>(properties: T, styleValue: Style): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `properties` | `T` | Yes | Typed props table that receives the supplied Reactily style values. |
| `styleValue` | `Style` | Yes | Reactily style table to apply. |

## Returns

`T`.

## Usage
```luau
local props = Reactily.applyStyle({
	Size = UDim2.fromOffset(200, 80),
}, {
	BackgroundTransparency = .2,
})
```
