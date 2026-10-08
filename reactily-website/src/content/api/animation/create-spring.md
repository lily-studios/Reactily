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
	Frequency = 8,
	Damping = 1,
})

Spring.setTarget(1)
```
## Works with

Pairs naturally with `useSpring`, bindings, component-owned lifecycle.
