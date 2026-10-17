---
title: Reactily.useSpring
sidebar_label: useSpring
sidebar_position: 27
description: API reference for Reactily.useSpring.
---

# `Reactily.useSpring`

Creates a component-owned spring and updates its target when the input changes.

## Signature
```luau
Reactily.useSpring<T>(target: T, options: SpringOptions?): Spring<T>
```
## Usage
```luau
local Spring = Reactily.useSpring(target, {
	Frequency = 8,
	Damping = 1,
})
```
## Works with

Pairs naturally with `createSpring`, component state, animation.

## Understanding this API

A spring produces motion toward a target using an interpolated value rather than an instantaneous jump.

### Practical guidance

For simple one-shot Roblox property changes, a Tween may be simpler. Springs are useful when the target may be updated repeatedly.

## Additional usage notes

### When to use it

Use this hook when a component needs a spring value that belongs to its own lifecycle.

### Behavior and ownership

Hook-managed values are retained by Reactily across ordinary component rerenders.

### Pitfalls to avoid

> **Note:** Use the hook only inside a Reactily function component or valid hook context.
