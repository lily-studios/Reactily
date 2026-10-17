---
title: Reactily.createTextLabel
sidebar_label: createTextLabel
sidebar_position: 12
description: API reference for Reactily.createTextLabel.
---

# `Reactily.createTextLabel`

Creates a typed virtual `TextLabel` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextLabel(props: TextLabelProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextLabel({
	Size = UDim2.fromOffset(300, 50),
	Text = "Reactily",
	TextSize = 28,
})
```

## Understanding this API

TextLabel displays text but is not itself interactive. For clicks use `createTextButton`; for editable input use `createTextBox`.

### Practical guidance

Type names such as `FrameProps` and `TextButtonProps` help Luau autocomplete. Host properties keep Roblox capitalization, while Reactily-specific methods and custom data fields use camelCase.

## Additional usage notes

### When to use it

Use a text label for non-interactive text such as descriptions, counters, and status values.

### Behavior and ownership

Changes to `Text` in a subsequent render update the managed TextLabel.

### Pitfalls to avoid

> **Note:** For a clickable label, prefer `createTextButton` and its supported event props instead.
