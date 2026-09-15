---
title: Reactily.createUIStroke
sidebar_label: createUIStroke
sidebar_position: 22
description: API reference for Reactily.createUIStroke.
---

# `Reactily.createUIStroke`

Creates a typed virtual `UIStroke` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIStroke(props: uiStrokeProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiStrokeProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local stroke = Reactily.createUIStroke({
	thickness = 2,
	transparency = .25,
})
```
