---
title: Reactily.createUIGridLayout
sidebar_label: createUIGridLayout
sidebar_position: 16
description: API reference for Reactily.createUIGridLayout.
---

# `Reactily.createUIGridLayout`

Creates a typed virtual `UIGridLayout` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIGridLayout(props: UIGridLayoutProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIGridLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local layout = Reactily.createUIGridLayout({
	CellSize = UDim2.fromOffset(120, 120),
	CellPadding = UDim2.fromOffset(8, 8),
})
```
