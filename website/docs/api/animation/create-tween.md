---
title: Reactily.createTween
sidebar_label: createTween
sidebar_position: 4
description: API reference for Reactily.createTween.
---

# `Reactily.createTween`

Creates an owned TweenService animation without playing it immediately.

## Signature
```typescript
Reactily.createTween(
	instance: Instance,
	goals: {[string]: any},
	options: tweenOptions
): animation
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `instance` | `Instance` | Yes | Roblox Instance used by the requested Reactily helper. |
| `goals` | `{[string]: any}` | Yes | Roblox TweenService goal property table. |
| `options` | `tweenOptions` | Yes | Typed Tween configuration. |

## Returns

An owned Reactily animation wrapper.

## Usage
```typescript
local animation = Reactily.createTween(frame, {
	BackgroundTransparency = 0,
}, {
	time = .2,
})
animation.play()
```
