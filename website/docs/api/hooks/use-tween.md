---
title: Reactily.useTween
sidebar_label: useTween
sidebar_position: 32
description: API reference for Reactily.useTween.
---

# `Reactily.useTween`

Creates and owns a TweenService animation while dependencies remain current.

## Signature
```typescript
Reactily.useTween(instance: Instance, goals: {[string]: any}, options: tweenOptions, dependencies: {any}?): animation?
```
## Usage
```typescript
Reactily.useTween(
	frame,
	{
		Position = targetPosition,
	},
	{
		time = .2,
	},
	{targetPosition}
)
```
## Works with

Pairs naturally with `createTween`, `useLayoutEffect`, component ownership.
