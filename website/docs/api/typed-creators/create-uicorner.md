---
title: Reactily.createUICorner
sidebar_label: createUICorner
sidebar_position: 14
description: API reference for Reactily.createUICorner.
---

# `Reactily.createUICorner`

Creates a typed virtual `UICorner` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUICorner(props: uiCornerProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiCornerProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local corner = Reactily.createUICorner({
	cornerRadius = UDim.new(0, 10),
})
```
