---
title: Reactily.createTextBox
sidebar_label: createTextBox
sidebar_position: 10
description: API reference for Reactily.createTextBox.
---

# `Reactily.createTextBox`

Creates a typed virtual `TextBox` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextBox(props: TextBoxProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextBoxProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextBox({
	Size = UDim2.fromOffset(280, 48),
	PlaceholderText = "Search...",
	Text = "",
})
```
