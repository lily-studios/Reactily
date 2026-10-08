---
title: Reactily.createFrame
sidebar_label: createFrame
sidebar_position: 4
description: API reference for Reactily.createFrame.
---

# `Reactily.createFrame`

Creates a typed virtual `Frame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createFrame(props: FrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `FrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createFrame({
	Size = UDim2.fromOffset(400, 240),
	BackgroundColor3 = Color3.fromRGB(30, 30, 34),
	BorderSizePixel = 0,
})
```
