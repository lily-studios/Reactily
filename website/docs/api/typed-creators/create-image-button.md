---
title: Reactily.createImageButton
sidebar_label: createImageButton
sidebar_position: 5
description: API reference for Reactily.createImageButton.
---

# `Reactily.createImageButton`

Creates a typed virtual `ImageButton` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createImageButton(props: imageButtonProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `imageButtonProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createImageButton({
	size = UDim2.fromOffset(64, 64),
	image = "rbxassetid://123456789",
	onActivated = function()
		print("clicked")
	end,
})
```
