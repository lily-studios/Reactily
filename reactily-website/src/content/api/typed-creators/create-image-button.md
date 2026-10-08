---
title: Reactily.createImageButton
sidebar_label: createImageButton
sidebar_position: 5
description: API reference for Reactily.createImageButton.
---

# `Reactily.createImageButton`

Creates a typed virtual `ImageButton` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createImageButton(props: ImageButtonProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ImageButtonProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createImageButton({
	Size = UDim2.fromOffset(64, 64),
	Image = "rbxassetid://123456789",
	OnActivated = function()
		print("clicked")
	end,
})
```
