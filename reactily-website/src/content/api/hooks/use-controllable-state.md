---
title: Reactily.useControllableState
sidebar_label: useControllableState
sidebar_position: 7
description: API reference for Reactily.useControllableState.
---

# `Reactily.useControllableState`

Creates state that can be controlled by props or managed internally.

## Signature
```luau
Reactily.useControllableState<T>(options: ControllableStateOptions<T>): (T, StateSetter<T>)
```
## Usage
```luau
local value, setValue = Reactily.useControllableState({
	Value = props.value,
	DefaultValue = 0,
	OnChanged = props.onChanged,
})
```
## Works with

Pairs naturally with controlled component props, `useEffectEvent`, typed creators.

## Understanding this API

This hook creates state that can be controlled by props or managed internally. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs creates state that can be controlled by props or managed internally.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
