---
title: Reactily.createImageLabel
sidebar_label: createImageLabel
sidebar_position: 6
description: API reference for Reactily.createImageLabel.
---

# `Reactily.createImageLabel`

Creates a typed virtual `ImageLabel` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createImageLabel(props: ImageLabelProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ImageLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createImageLabel({
	Size = UDim2.fromOffset(128, 128),
	Image = "rbxassetid://123456789",
})
```

## Understanding this API

ImageLabel displays an image without button interaction. Use ImageButton when the user needs to activate it.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the ImageLabel capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
