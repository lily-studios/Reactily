---
title: Reactily.sequenceAnimations
sidebar_label: sequenceAnimations
sidebar_position: 7
description: API reference for Reactily.sequenceAnimations.
---

# `Reactily.sequenceAnimations`

Creates a group that plays each animation after the previous one completes.

## Signature
```typescript
Reactily.sequenceAnimations(animations: {animationPlayable}): animationGroup
```
## Usage
```typescript
local group = Reactily.sequenceAnimations({
	firstAnimation,
	Reactily.createAnimationDelay(.1),
	secondAnimation,
})

group.play()
```
## Works with

Pairs naturally with `createTween`, `createAnimationDelay`, `parallelAnimations`.
