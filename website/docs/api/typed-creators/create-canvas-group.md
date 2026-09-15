---
title: Reactily.createCanvasGroup
sidebar_label: createCanvasGroup
sidebar_position: 3
description: API reference for Reactily.createCanvasGroup.
---

# `Reactily.createCanvasGroup`

Creates a typed virtual `CanvasGroup` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createCanvasGroup(props: canvasGroupProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `canvasGroupProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createCanvasGroup({
	size = UDim2.fromOffset(300, 180),
	groupTransparency = 0,
})
```
