---
title: Reactily.createUIStroke
sidebar_label: createUIStroke
sidebar_position: 22
description: API reference for Reactily.createUIStroke.
---

# `Reactily.createUIStroke`

Creates a typed virtual `UIStroke` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIStroke(props: UIStrokeProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIStrokeProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local stroke = Reactily.createUIStroke({
	Thickness = 2,
	Transparency = .25,
})
```
