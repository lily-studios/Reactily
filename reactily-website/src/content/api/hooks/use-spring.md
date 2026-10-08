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
Reactily.useSpring<T>(target: T, options: springOptions?): spring<T>
```
## Usage
```luau
local spring = Reactily.useSpring(target, {
	frequency = 8,
	damping = 1,
})
```
## Works with

Pairs naturally with `createSpring`, component state, animation.
