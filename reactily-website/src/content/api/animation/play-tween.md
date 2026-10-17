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

An owned Reactily animation handle with `Play()`, `Cancel()`, `Delete()`, `IsDeleted()`, and `OnCompleted()` methods.

## Usage
```luau
local Animation = Reactily.playTween(Frame, {
	BackgroundTransparency = 0,
}, {
	Time = 0.2,
})
```

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use this helper when creates and immediately plays an owned TweenService animation.

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
