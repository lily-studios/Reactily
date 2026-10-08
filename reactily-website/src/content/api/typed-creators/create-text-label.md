---
title: Reactily.createTextLabel
sidebar_label: createTextLabel
sidebar_position: 12
description: API reference for Reactily.createTextLabel.
---

# `Reactily.createTextLabel`

Creates a typed virtual `TextLabel` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextLabel(props: TextLabelProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextLabel({
	Size = UDim2.fromOffset(300, 50),
	Text = "Reactily",
	TextSize = 28,
})
```
