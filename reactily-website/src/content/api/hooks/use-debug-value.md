---
title: Reactily.useDebugValue
description: Associates a formatted debug value with the currently rendering component.
---

# `Reactily.useDebugValue`

Associates a formatted debug value with the currently rendering component. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useDebugValue<T>(value: T, formatter: ((value: T) -> any)?)
```

## Usage

```luau
Reactily.useDebugValue(value, tostring)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

This hook associates a formatted debug value with the currently rendering component. This export is included in Reactily v2.2.0 (API v1). Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs associates a formatted debug value with the currently rendering component. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
