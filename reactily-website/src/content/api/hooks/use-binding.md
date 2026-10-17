---
title: Reactily.useBinding
sidebar_label: useBinding
sidebar_position: 3
description: API reference for Reactily.useBinding.
---

# `Reactily.useBinding`

Creates and owns a Reactily binding for the component lifetime.

## Signature
```luau
Reactily.useBinding<T>(initialValue: T): Binding<T>
```
## Usage
```luau
local Binding = Reactily.useBinding(0)
```
## Works with

Pairs naturally with `bindProperty`, `bindAttribute`, binding transforms.

## Understanding this API

This hook creates and owns a Reactily binding for the component lifetime. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs creates and owns a Reactily binding for the component lifetime.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
