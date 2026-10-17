---
title: Reactily.useTransition
sidebar_label: useTransition
sidebar_position: 31
description: API reference for Reactily.useTransition.
---

# `Reactily.useTransition`

Creates a low-priority transition starter and pending state.

## Signature
```luau
Reactily.useTransition(): (boolean, TransitionStarter)
```
## Usage
```luau
local isPending, startTransition = Reactily.useTransition()

startTransition(function()
	updateState()
end)
```
## Works with

Pairs naturally with `startTransition`, `useDeferredValue`, stores.

## Understanding this API

Transitions distinguish lower-urgency updates from immediate interaction work so Reactily can schedule them appropriately.

### Practical guidance

Do not use a transition to delay Roblox engine side effects arbitrarily; it is primarily a scheduling mechanism for Reactily updates.

## Additional usage notes

### When to use it

Use this hook when the component needs creates a low-priority transition starter and pending state.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
