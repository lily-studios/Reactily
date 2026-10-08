---
title: Reactily.createTextButton
sidebar_label: createTextButton
sidebar_position: 11
description: API reference for Reactily.createTextButton.
---

# `Reactily.createTextButton`

Creates a typed virtual `TextButton` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextButton(props: TextButtonProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextButtonProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextButton({
	Size = UDim2.fromOffset(220, 56),
	Text = "Continue",
	OnActivated = function()
		print("Continue")
	end,
})
```
