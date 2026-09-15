---
title: Reactily.createTextButton
sidebar_label: createTextButton
sidebar_position: 11
description: API reference for Reactily.createTextButton.
---

# `Reactily.createTextButton`

Creates a typed virtual `TextButton` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createTextButton(props: textButtonProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `textButtonProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createTextButton({
	size = UDim2.fromOffset(220, 56),
	text = "Continue",
	onActivated = function()
		print("Continue")
	end,
})
```
