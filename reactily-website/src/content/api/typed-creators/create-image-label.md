---
title: Reactily.createImageLabel
sidebar_label: createImageLabel
sidebar_position: 6
description: API reference for Reactily.createImageLabel.
---

# `Reactily.createImageLabel`

Creates a typed virtual `ImageLabel` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createImageLabel(props: ImageLabelProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `ImageLabelProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createImageLabel({
	Size = UDim2.fromOffset(128, 128),
	Image = "rbxassetid://123456789",
})
```
