---
title: Reactily.createBillboardGui
sidebar_label: createBillboardGui
sidebar_position: 2
description: API reference for Reactily.createBillboardGui.
---

# `Reactily.createBillboardGui`

Creates a typed virtual `BillboardGui` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createBillboardGui(props: BillboardGuiProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `BillboardGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createBillboardGui({
	Size = UDim2.fromOffset(240, 80),
	AlwaysOnTop = true,
}, {
	Reactily.createTextLabel({
		Size = UDim2.fromScale(1, 1),
		Text = "Item",
	}),
})
```
