---
title: Reactily.createVideoFrame
sidebar_label: createVideoFrame
sidebar_position: 24
description: API reference for Reactily.createVideoFrame.
---

# `Reactily.createVideoFrame`

Creates a typed virtual `VideoFrame` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createVideoFrame(props: VideoFrameProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `VideoFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createVideoFrame({
	Size = UDim2.fromOffset(640, 360),
	Video = "rbxassetid://123456789",
})
```
