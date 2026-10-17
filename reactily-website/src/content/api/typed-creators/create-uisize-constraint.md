---
title: Reactily.createUISizeConstraint
sidebar_label: createUISizeConstraint
sidebar_position: 21
description: API reference for Reactily.createUISizeConstraint.
---

# `Reactily.createUISizeConstraint`

Creates a typed virtual `UISizeConstraint` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUISizeConstraint(props: UISizeConstraintProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UISizeConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local constraint = Reactily.createUISizeConstraint({
	MinSize = Vector2.new(200, 100),
	MaxSize = Vector2.new(800, 600),
})
```

## Understanding this API

This creator targets the Roblox `uisizeconstraint` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the UISizeConstraint capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
