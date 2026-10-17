---
title: Reactily.sequenceAnimations
sidebar_label: sequenceAnimations
sidebar_position: 7
description: API reference for Reactily.sequenceAnimations.
---

# `Reactily.sequenceAnimations`

Creates a group that plays each animation after the previous one completes.

## Signature
```luau
Reactily.sequenceAnimations(animations: {AnimationPlayable}): AnimationGroup
```
## Usage
```luau
local Group = Reactily.sequenceAnimations({
	firstAnimation,
	Reactily.createAnimationDelay(.1),
	secondAnimation,
})

Group.Play()
```
## Works with

Pairs naturally with `createTween`, `createAnimationDelay`, `parallelAnimations`.

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use this helper when creates a group that plays each animation after the previous one completes.

### Behavior and ownership

Animation helpers have different ownership and playback behavior. Review the return type before composing them.

### Pitfalls to avoid

> **Note:** Do not assume every animation helper returns a Tween or starts playing immediately.
