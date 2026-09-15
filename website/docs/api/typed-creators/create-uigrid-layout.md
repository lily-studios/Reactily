---
title: Reactily.createUIGridLayout
sidebar_label: createUIGridLayout
sidebar_position: 16
description: API reference for Reactily.createUIGridLayout.
---

# `Reactily.createUIGridLayout`

Creates a typed virtual `UIGridLayout` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIGridLayout(props: uiGridLayoutProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiGridLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local layout = Reactily.createUIGridLayout({
	cellSize = UDim2.fromOffset(120, 120),
	cellPadding = UDim2.fromOffset(8, 8),
})
```
