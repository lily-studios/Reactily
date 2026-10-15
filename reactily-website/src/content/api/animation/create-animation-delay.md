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
Reactily.createAnimationDelay(seconds: number): AnimationPlayable
```
## Usage
```luau
local delay = Reactily.createAnimationDelay(.2)
```
## Works with

Pairs naturally with `createTween`, `parallelAnimations`, `sequenceAnimations`, `useOwned`.

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use this creator when you need the AnimationDelay capability described above, and keep its result under a clear owner.

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
