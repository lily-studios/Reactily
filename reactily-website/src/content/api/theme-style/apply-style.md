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

## Additional usage notes

### When to use it

Use this helper when applies a style table onto a cloned typed props table.

### Behavior and ownership

Theme and style helpers organize reusable property sets for consistent UI rendering.

### Pitfalls to avoid

> **Note:** Do not mix camelCase framework metadata and native PascalCase Roblox properties.
