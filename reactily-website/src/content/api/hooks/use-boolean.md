---
title: Reactily.useBoolean
sidebar_label: useBoolean
sidebar_position: 4
description: API reference for Reactily.useBoolean.
---

# `Reactily.useBoolean`

Provides boolean state plus stable enable, disable, and toggle functions.

## Signature
```luau
Reactily.useBoolean(initialValue: boolean?): (boolean, () -> (), () -> (), () -> ())
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `boolean?` | No | Initial typed value. |

## Returns

`(boolean, () -> (), () -> (), () -> ())`.

## Usage
```luau
local enabled, enable, disable, toggle = Reactily.useBoolean(false)
```

## Understanding this API

This hook provides boolean state plus stable enable, disable, and toggle functions. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs provides boolean state plus stable enable, disable, and toggle functions.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
