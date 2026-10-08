---
title: Reactily.playTween
sidebar_label: playTween
sidebar_position: 6
description: API reference for Reactily.playTween.
---

# `Reactily.playTween`

Creates and immediately plays an owned TweenService animation.

## Signature
```luau
Reactily.playTween(
	instance: Instance,
	goals: {[string]: any},
	options: TweenOptions
): Animation
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `instance` | `Instance` | Yes | Roblox Instance used by the requested Reactily helper. |
| `goals` | `{[string]: any}` | Yes | Roblox TweenService goal property table. |
| `options` | `TweenOptions` | Yes | Typed Tween configuration. |

## Returns

An owned Reactily animation wrapper.

## Usage
```luau
local Animation = Reactily.playTween(frame, {
	BackgroundTransparency = 0,
}, {
	Time = .2,
})
```
