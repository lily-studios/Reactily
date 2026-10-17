---
title: Reactily.useTween
sidebar_label: useTween
sidebar_position: 32
description: API reference for Reactily.useTween.
---

# `Reactily.useTween`

Creates and owns a TweenService animation while dependencies remain current.

## Signature
```luau
Reactily.useTween(instance: Instance, goals: {[string]: any}, options: TweenOptions, dependencies: {any}?): Animation?
```
## Usage
```luau
Reactily.useTween(
	frame,
	{
		Position = targetPosition,
	},
	{
		Time = .2,
	},
	{targetPosition}
)
```
## Works with

Pairs naturally with `createTween`, `useLayoutEffect`, component ownership.

## Understanding this API

Tween-based animation interpolates properties or values over a configured duration.

### Practical guidance

Keep animation ownership clear; when a component unmounts, its animation should not continue modifying a deleted or repurposed GUI object.

## Additional usage notes

### When to use it

Use this hook for component-owned tween behavior rather than unmanaged TweenService connections.

### Behavior and ownership

The hook maintains tween-related state or ownership across renders.

### Pitfalls to avoid

> **Note:** Avoid starting overlapping tweens each render without controlling their lifetime.
