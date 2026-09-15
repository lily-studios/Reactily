---
title: Reactily.createImageLabel
sidebar_label: createImageLabel
sidebar_position: 6
description: API reference for Reactily.createImageLabel.
---

# `Reactily.createImageLabel`

Creates a typed virtual `ImageLabel` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createImageLabel(props: imageLabelProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `imageLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createImageLabel({
	size = UDim2.fromOffset(128, 128),
	image = "rbxassetid://123456789",
})
```
