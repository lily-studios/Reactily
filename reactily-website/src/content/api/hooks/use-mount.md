---
title: Reactily.useMount
sidebar_label: useMount
sidebar_position: 21
description: API reference for Reactily.useMount.
---

# `Reactily.useMount`

Runs an effect once when the component mounts.

## Signature
```luau
Reactily.useMount(callback: () -> (() -> ())?): ()
```
## Usage
```luau
Reactily.useMount(function()
	print("Mounted")
end)
```
## Works with

Pairs naturally with `useUnmount`, `useOwned`, subscriptions.

## Understanding this API

This hook runs an effect once when the component mounts. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs runs an effect once when the component mounts.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
