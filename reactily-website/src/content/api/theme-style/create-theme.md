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
