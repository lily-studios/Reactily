---
title: Reactily.createTextBox
sidebar_label: createTextBox
sidebar_position: 10
description: API reference for Reactily.createTextBox.
---

# `Reactily.createTextBox`

Creates a typed virtual `TextBox` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextBox(props: TextBoxProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextBoxProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextBox({
	Size = UDim2.fromOffset(280, 48),
	PlaceholderText = "Search...",
	Text = "",
})
```

## Understanding this API

TextBox is intended for user text entry. Use native text/input property names and connect relevant events through the host props supported by Reactily.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use this creator when you need the TextBox capability described above, and keep its result under a clear owner.

### Behavior and ownership

A typed creator returns a Reactily element description. It does not directly parent a new Roblox Instance.

### Pitfalls to avoid

> **Note:** Use the official Roblox property names inside props, and render the result through a root.
