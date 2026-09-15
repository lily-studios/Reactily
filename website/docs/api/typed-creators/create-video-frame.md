---
title: Reactily.createVideoFrame
sidebar_label: createVideoFrame
sidebar_position: 24
description: API reference for Reactily.createVideoFrame.
---

# `Reactily.createVideoFrame`

Creates a typed virtual `VideoFrame` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createVideoFrame(props: videoFrameProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `videoFrameProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createVideoFrame({
	size = UDim2.fromOffset(640, 360),
	video = "rbxassetid://123456789",
})
```
