---
title: Reactily.createScreenGui
sidebar_label: createScreenGui
sidebar_position: 7
description: API reference for Reactily.createScreenGui.
---

# `Reactily.createScreenGui`

Creates a typed virtual `ScreenGui` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createScreenGui(props: ScreenGuiProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ScreenGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createScreenGui({
	Name = "Interface",
	ResetOnSpawn = false,
}, {
	Reactily.createFrame({
		Size = UDim2.fromScale(1, 1),
	}),
})
```

## Understanding this API

A `ScreenGui` forms a top-level 2D interface displayed through the player GUI hierarchy.

### Practical guidance

When using one as the root of a Reactily tree, parent the render root to a suitable GUI container and supply children under the `ScreenGui` element. `ResetOnSpawn` is a native Roblox property.

## Additional usage notes

### When to use it

Use this creator when you need the ScreenGui capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
