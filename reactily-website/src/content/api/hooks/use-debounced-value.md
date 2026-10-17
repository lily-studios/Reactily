---
title: Reactily.useDebouncedValue
sidebar_label: useDebouncedValue
sidebar_position: 9
description: API reference for Reactily.useDebouncedValue.
---

# `Reactily.useDebouncedValue`

Returns a value that updates after the requested one-shot delay.

## Signature
```luau
Reactily.useDebouncedValue<T>(value: T, delaySeconds: number): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `value` | `T` | Yes | Typed value passed to the hook/helper. |
| `delaySeconds` | `number` | Yes | One-shot debounce delay in seconds. Must be non-negative. |

## Returns

`T`.

## Usage
```luau
local debouncedQuery = Reactily.useDebouncedValue(query, .2)
```

## Understanding this API

This hook returns a value that updates after the requested one-shot delay. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns a value that updates after the requested one-shot delay.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
