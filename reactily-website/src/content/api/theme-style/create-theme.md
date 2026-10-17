---
title: Reactily.createTheme
sidebar_label: createTheme
sidebar_position: 4
description: API reference for Reactily.createTheme.
---

# `Reactily.createTheme`

Creates change-only typed theme token state.

## Signature
```luau
Reactily.createTheme<T>(initialValue: T): Theme<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

A `Theme<T>`.

## Usage
```luau
local Theme = Reactily.createTheme({
	accent = Color3.fromRGB(80, 120, 255),
})
```

## Additional usage notes

### When to use it

Use this creator when you need the Theme capability described above, and keep its result under a clear owner.

### Behavior and ownership

Theme and style helpers organize reusable property sets for consistent UI rendering.

### Pitfalls to avoid

> **Note:** Do not mix camelCase framework metadata and native PascalCase Roblox properties.
