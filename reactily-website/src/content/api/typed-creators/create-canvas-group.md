---
title: Reactily.createCanvasGroup
sidebar_label: createCanvasGroup
sidebar_position: 3
description: API reference for Reactily.createCanvasGroup.
---

# `Reactily.createCanvasGroup`

Creates a typed virtual `CanvasGroup` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createCanvasGroup(props: CanvasGroupProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `CanvasGroupProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createCanvasGroup({
	Size = UDim2.fromOffset(300, 180),
	GroupTransparency = 0,
})
```

## Understanding this API

This creator targets the Roblox `canvasgroup` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the CanvasGroup capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
