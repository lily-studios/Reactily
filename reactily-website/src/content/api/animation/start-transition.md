---
title: Reactily.startTransition
sidebar_label: startTransition
sidebar_position: 8
description: API reference for Reactily.startTransition.
---

# `Reactily.startTransition`

Starts low-priority one-shot transition work.

## Signature
```luau
Reactily.startTransition(callback: () -> ()): thread
```
## Usage
```luau
Reactily.startTransition(function()
	updateState()
end)
```
## Works with

Pairs naturally with `useTransition`, `useDeferredValue`, low-priority store updates.

## Understanding this API

This animation operation fits into Reactily’s handling of time-based UI behavior. Check the return type carefully: composing a sequence, creating a spring, and playing a Tween have different lifetime and playback rules.

### Practical guidance

Review the return type before using the result: an animation handle may need to be played and eventually cleaned up, whereas a transition helper may schedule an existing callback. Keep native property names in official Roblox casing.

## Additional usage notes

### When to use it

Use transitions to mark updates that need not block a higher-priority interaction.

### Behavior and ownership

Work inside the callback is scheduled in the transition context where supported.

### Pitfalls to avoid

> **Note:** Do not use it to defer operations that must complete immediately before reading their result.
