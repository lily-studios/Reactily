---
title: Reactily.createSpring
sidebar_label: createSpring
sidebar_position: 3
description: API reference for Reactily.createSpring.
---

# `Reactily.createSpring`

Creates a spring for number, Vector2, Vector3, or Color3 values.

## Signature
```typescript
Reactily.createSpring<T>(initialValue: T, options: springOptions?): spring<T>
```
## Usage
```typescript
local spring = Reactily.createSpring(0, {
	frequency = 8,
	damping = 1,
})

spring.setTarget(1)
```
## Works with

Pairs naturally with `useSpring`, bindings, component-owned lifecycle.
