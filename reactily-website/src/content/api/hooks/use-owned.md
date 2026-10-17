---
title: Reactily.useOwned
sidebar_label: useOwned
sidebar_position: 22
description: API reference for Reactily.useOwned.
---

# `Reactily.useOwned`

Registers a delete-capable object for automatic component cleanup.

## Signature
```luau
Reactily.useOwned<T>(value: T): T
```
## Usage
```luau
local Binding = Reactily.useOwned(
	Reactily.createBinding(0)
)
```
## Works with

Pairs naturally with bindings, springs, animations, diagnostics, lifecycle owners.

## Understanding this API

This hook registers a delete-capable object for automatic component cleanup. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs registers a delete-capable object for automatic component cleanup.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
