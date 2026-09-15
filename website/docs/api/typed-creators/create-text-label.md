---
title: Reactily.createTextLabel
sidebar_label: createTextLabel
sidebar_position: 12
description: API reference for Reactily.createTextLabel.
---

# `Reactily.createTextLabel`

Creates a typed virtual `TextLabel` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createTextLabel(props: textLabelProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `textLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createTextLabel({
	size = UDim2.fromOffset(300, 50),
	text = "Reactily",
	textSize = 28,
})
```
