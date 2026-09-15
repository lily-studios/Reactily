---
title: Reactily.createUIGradient
sidebar_label: createUIGradient
sidebar_position: 15
description: API reference for Reactily.createUIGradient.
---

# `Reactily.createUIGradient`

Creates a typed virtual `UIGradient` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIGradient(props: uiGradientProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiGradientProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local gradient = Reactily.createUIGradient({
	rotation = 90,
})
```
