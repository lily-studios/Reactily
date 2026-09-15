---
title: Reactily.createBillboardGui
sidebar_label: createBillboardGui
sidebar_position: 2
description: API reference for Reactily.createBillboardGui.
---

# `Reactily.createBillboardGui`

Creates a typed virtual `BillboardGui` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createBillboardGui(props: billboardGuiProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `billboardGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createBillboardGui({
	size = UDim2.fromOffset(240, 80),
	alwaysOnTop = true,
}, {
	Reactily.createTextLabel({
		size = UDim2.fromScale(1, 1),
		text = "Item",
	}),
})
```
