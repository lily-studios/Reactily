---
title: Reactily.createScrollingFrame
sidebar_label: createScrollingFrame
sidebar_position: 8
description: API reference for Reactily.createScrollingFrame.
---

# `Reactily.createScrollingFrame`

Creates a typed virtual `ScrollingFrame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createScrollingFrame(props: ScrollingFrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ScrollingFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createScrollingFrame({
	Size = UDim2.fromOffset(400, 500),
	CanvasSize = UDim2.fromOffset(0, 1200),
	ScrollBarThickness = 8,
})
```

## Understanding this API

ScrollingFrame provides a scrollable view of child UI. For very long datasets, combine it with virtualization to limit mounted rows.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the ScrollingFrame capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
