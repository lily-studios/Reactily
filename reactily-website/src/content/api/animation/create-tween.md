---
title: Reactily.createTween
sidebar_label: createTween
sidebar_position: 4
description: API reference for Reactily.createTween.
---

# `Reactily.createTween`

Creates an owned TweenService animation without playing it immediately.

## Signature
```luau
Reactily.createTween(
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

An owned `Animation` handle with PascalCase `Play()`, `Cancel()`, `Delete()`, and `IsDeleted()` methods.

## Usage
```luau
local Animation = Reactily.createTween(Frame, {
	BackgroundTransparency = 0,
}, {
	Time = 0.2,
})
Animation.Play()
```

## Understanding this API

This creates a managed TweenService animation targeting an existing Instance. The returned animation is separate from the virtual element tree.

### Practical guidance

Creation alone does not play it. Keep the handle to start, cancel, and delete the animation as its owning UI component or controller is cleaned up.

## Additional usage notes

### When to use it

Use this creator when you need the Tween capability described above, and keep its result under a clear owner.

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
