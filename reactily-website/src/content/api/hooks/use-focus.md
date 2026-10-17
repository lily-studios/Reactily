---
title: Reactily.useFocus
sidebar_label: useFocus
sidebar_position: 14
description: API reference for Reactily.useFocus.
---

# `Reactily.useFocus`

Returns focus state for a GuiObject.

## Signature
```luau
Reactily.useFocus(object: GuiObject): boolean
```
## Usage
```luau
local isFocused = Reactily.useFocus(button)
```
## Works with

Pairs naturally with `createFocusGroup`, typed buttons, focus navigation.

## Understanding this API

This hook returns focus state for a GuiObject. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns focus state for a GuiObject.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
