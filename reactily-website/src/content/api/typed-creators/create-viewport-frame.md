---
title: Reactily.createViewportFrame
sidebar_label: createViewportFrame
sidebar_position: 25
description: API reference for Reactily.createViewportFrame.
---

# `Reactily.createViewportFrame`

Creates a typed virtual `ViewportFrame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createViewportFrame(props: ViewportFrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ViewportFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createViewportFrame({
	Size = UDim2.fromOffset(500, 300),
	CurrentCamera = camera,
})
```

## Understanding this API

ViewportFrame displays a 3D scene in a 2D UI region. Roblox camera and scene content need to be configured using normal engine rules.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the ViewportFrame capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
