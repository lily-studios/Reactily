---
title: Reactily.createStyle
sidebar_label: createStyle
sidebar_position: 3
description: API reference for Reactily.createStyle.
---

# `Reactily.createStyle`

Merges ordered style tables into one new style.

## Signature
```luau
Reactily.createStyle(styles: {Style}): Style
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `styles` | `{Style}` | Yes | Ordered style tables. Later entries overwrite earlier properties. |

## Returns

A new merged Reactily style table.

## Usage
```luau
local styleValue = Reactily.createStyle({
	baseStyle,
	selectedStyle,
})
```

## Additional usage notes

### When to use it

Use this creator when you need the Style capability described above, and keep its result under a clear owner.

### Behavior and ownership

Theme and style helpers organize reusable property sets for consistent UI rendering.

### Pitfalls to avoid

> **Note:** Do not mix camelCase framework metadata and native PascalCase Roblox properties.
