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

## Understanding this API

ImageButton behaves as an interactive GUI control. Use it when the visual target is an image but you still need button activation.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the ImageButton capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
