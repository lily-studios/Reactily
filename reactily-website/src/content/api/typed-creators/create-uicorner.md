---
title: Reactily.createUICorner
sidebar_label: createUICorner
sidebar_position: 14
description: API reference for Reactily.createUICorner.
---

# `Reactily.createUICorner`

Creates a typed virtual `UICorner` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUICorner(props: UICornerProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UICornerProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local corner = Reactily.createUICorner({
	CornerRadius = UDim.new(0, 10),
})
```

## Understanding this API

This creator targets the Roblox `uicorner` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the UICorner capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
