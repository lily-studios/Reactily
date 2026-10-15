---
title: Reactily.useDeferredValue
sidebar_label: useDeferredValue
sidebar_position: 10
description: API reference for Reactily.useDeferredValue.
---

# `Reactily.useDeferredValue`

Returns a deferred copy of a changing value using one-shot scheduling.

## Signature
```luau
Reactily.useDeferredValue<T>(value: T): T
```
## Usage
```luau
local deferredValue = Reactily.useDeferredValue(value)
```
## Works with

Pairs naturally with `useTransition`, stores, search/filter UIs.

## Understanding this API

This hook returns a deferred copy of a changing value using one-shot scheduling. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns a deferred copy of a changing value using one-shot scheduling.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
