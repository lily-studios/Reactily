---
title: Reactily.createUIScale
sidebar_label: createUIScale
sidebar_position: 20
description: API reference for Reactily.createUIScale.
---

# `Reactily.createUIScale`

Creates a typed virtual `UIScale` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIScale(props: UIScaleProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIScaleProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Scale = Reactily.createUIScale({
	Scale = 1.1,
})
```

## Understanding this API

This creator targets the Roblox `uiscale` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the UIScale capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
