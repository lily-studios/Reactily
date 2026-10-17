---
title: Reactily.useCounter
sidebar_label: useCounter
sidebar_position: 8
description: API reference for Reactily.useCounter.
---

# `Reactily.useCounter`

Provides numeric state plus increment/decrement/reset/set controls.

## Signature
```luau
Reactily.useCounter(initialValue: number?): (number, CounterControls)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `number?` | No | Initial typed value. |

## Returns

`(number, CounterControls)`.

## Usage
```luau
local count, controls = Reactily.useCounter(0)
controls.increment()
```

## Understanding this API

This hook provides numeric state plus increment/decrement/reset/set controls. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs provides numeric state plus increment/decrement/reset/set controls.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
