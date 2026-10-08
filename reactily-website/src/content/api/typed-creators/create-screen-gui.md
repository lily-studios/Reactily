---
title: Reactily.createScreenGui
sidebar_label: createScreenGui
sidebar_position: 7
description: API reference for Reactily.createScreenGui.
---

# `Reactily.createScreenGui`

Creates a typed virtual `ScreenGui` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createScreenGui(props: ScreenGuiProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ScreenGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createScreenGui({
	Name = "Interface",
	ResetOnSpawn = false,
}, {
	Reactily.createFrame({
		Size = UDim2.fromScale(1, 1),
	}),
})
```
