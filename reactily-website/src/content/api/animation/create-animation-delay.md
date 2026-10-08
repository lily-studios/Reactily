---
title: Reactily.createAnimationDelay
sidebar_label: createAnimationDelay
sidebar_position: 2
description: API reference for Reactily.createAnimationDelay.
---

# `Reactily.createAnimationDelay`

Creates a one-shot delay step compatible with Reactily animation sequences.

## Signature
```luau
Reactily.createAnimationDelay(seconds: number): animationPlayable
```
## Usage
```luau
local delay = Reactily.createAnimationDelay(.2)
```
## Works with

Pairs naturally with `createTween`, `parallelAnimations`, `sequenceAnimations`, `useOwned`.
