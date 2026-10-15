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

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use this helper when creates a group that starts every animation together.

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
