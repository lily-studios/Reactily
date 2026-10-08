---
title: Reactily.parallelAnimations
sidebar_label: parallelAnimations
sidebar_position: 5
description: API reference for Reactily.parallelAnimations.
---

# `Reactily.parallelAnimations`

Creates a group that starts every animation together.

## Signature
```luau
Reactily.parallelAnimations(animations: {AnimationPlayable}): AnimationGroup
```
## Usage
```luau
local Group = Reactily.parallelAnimations({
	firstAnimation,
	secondAnimation,
})

Group.Play()
```
## Works with

Pairs naturally with `createTween`, `createAnimationDelay`, `sequenceAnimations`.
