---
title: Reactily.usePrevious
sidebar_label: usePrevious
sidebar_position: 24
description: API reference for Reactily.usePrevious.
---

# `Reactily.usePrevious`

Returns the value from the previous completed render, or `nil` initially.

## Signature
```luau
Reactily.usePrevious<T>(value: T): T?
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `value` | `T` | Yes | Typed value passed to the hook/helper. |

## Returns

`T?`.

## Usage
```luau
local previous = Reactily.usePrevious(current)
```

## Understanding this API

This hook returns the value from the previous completed render, or `nil` initially. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns the value from the previous completed render, or nil initially.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
