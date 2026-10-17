---
title: Reactily.createUIGridLayout
sidebar_label: createUIGridLayout
sidebar_position: 16
description: API reference for Reactily.createUIGridLayout.
---

# `Reactily.createUIGridLayout`

Creates a typed virtual `UIGridLayout` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIGridLayout(props: UIGridLayoutProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIGridLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local layout = Reactily.createUIGridLayout({
	CellSize = UDim2.fromOffset(120, 120),
	CellPadding = UDim2.fromOffset(8, 8),
})
```

## Understanding this API

This creator targets the Roblox `uigridlayout` host type while returning a Reactily virtual element description. The root renderer handles instance creation and later updates.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the UIGridLayout capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
