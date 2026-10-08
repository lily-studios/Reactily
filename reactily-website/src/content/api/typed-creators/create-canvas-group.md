---
title: Reactily.createCanvasGroup
sidebar_label: createCanvasGroup
sidebar_position: 3
description: API reference for Reactily.createCanvasGroup.
---

# `Reactily.createCanvasGroup`

Creates a typed virtual `CanvasGroup` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createCanvasGroup(props: CanvasGroupProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `CanvasGroupProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createCanvasGroup({
	Size = UDim2.fromOffset(300, 180),
	GroupTransparency = 0,
})
```
