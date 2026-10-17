---
title: Reactily.createSpring
sidebar_label: createSpring
sidebar_position: 3
description: API reference for Reactily.createSpring.
---

# `Reactily.createSpring`

Creates a spring for number, Vector2, Vector3, or Color3 values.

## Signature
```luau
Reactily.createSpring<T>(initialValue: T, options: SpringOptions?): Spring<T>
```
## Usage
```luau
local Spring = Reactily.createSpring(0, {
	frequency = 8,
	damping = 1,
})

Spring.setTarget(1)
```
## Works with

Pairs naturally with `useSpring`, bindings, component-owned lifecycle.

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use a spring when a changing value needs smooth, spring-like motion.

### Behavior and ownership

Its target and current value follow the spring’s configured behavior; the result is not itself a TweenService Tween.

### Pitfalls to avoid

> **Note:** Check the expected spring option keys and supported value types before configuring it.
