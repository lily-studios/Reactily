---
title: Reactily.useId
sidebar_label: useId
sidebar_position: 16
description: API reference for Reactily.useId.
---

# `Reactily.useId`

Returns a stable component-local identifier.

## Signature
```luau
Reactily.useId(): string
```
## Usage
```luau
local Id = Reactily.useId()
```
## Works with

Pairs naturally with component identity, generated names, refs.

## Understanding this API

This hook returns a stable component-local identifier. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns a stable component-local identifier.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
