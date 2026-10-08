---
title: Reactily.createUIGradient
sidebar_label: createUIGradient
sidebar_position: 15
description: API reference for Reactily.createUIGradient.
---

# `Reactily.createUIGradient`

Creates a typed virtual `UIGradient` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIGradient(props: UIGradientProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIGradientProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local gradient = Reactily.createUIGradient({
	Rotation = 90,
})
```
