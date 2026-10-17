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

## Understanding this API

BillboardGui displays GUI content in the 3D world. Its adornee and positioning behavior come from the Roblox class.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the BillboardGui capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
