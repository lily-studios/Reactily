---
title: Reactily.createTextBox
sidebar_label: createTextBox
sidebar_position: 10
description: API reference for Reactily.createTextBox.
---

# `Reactily.createTextBox`

Creates a typed virtual `TextBox` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createTextBox(props: textBoxProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `textBoxProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createTextBox({
	size = UDim2.fromOffset(280, 48),
	placeholderText = "Search...",
	text = "",
})
```
