---
title: Reactily.createUIStroke
sidebar_label: createUIStroke
sidebar_position: 22
description: API reference for Reactily.createUIStroke.
---

# `Reactily.createUIStroke`

Creates a typed virtual `UIStroke` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIStroke(props: UIStrokeProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIStrokeProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local stroke = Reactily.createUIStroke({
	Thickness = 2,
	Transparency = .25,
})
```

## Understanding this API

This creator targets the Roblox `uistroke` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the UIStroke capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
