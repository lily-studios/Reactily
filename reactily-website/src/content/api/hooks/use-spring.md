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
