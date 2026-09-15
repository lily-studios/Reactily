---
title: Reactily.parallelAnimations
sidebar_label: parallelAnimations
sidebar_position: 5
description: API reference for Reactily.parallelAnimations.
---

# `Reactily.parallelAnimations`

Creates a group that starts every animation together.

## Signature
```typescript
Reactily.parallelAnimations(animations: {animationPlayable}): animationGroup
```
## Usage
```typescript
local group = Reactily.parallelAnimations({
	firstAnimation,
	secondAnimation,
})

group.play()
```
## Works with

Pairs naturally with `createTween`, `createAnimationDelay`, `sequenceAnimations`.
