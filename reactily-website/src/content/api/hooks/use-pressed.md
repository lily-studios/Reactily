---
title: Reactily.usePressed
sidebar_label: usePressed
sidebar_position: 23
description: API reference for Reactily.usePressed.
---

# `Reactily.usePressed`

Returns pressed state for a GuiButton or GuiObject input surface.

## Signature
```luau
Reactily.usePressed(object: GuiObject): boolean
```
## Usage
```luau
local isPressed = Reactily.usePressed(button)
```
## Works with

Pairs naturally with `useHover`, `useFocus`, interactive styles.

## Understanding this API

This hook returns pressed state for a GuiButton or GuiObject input surface. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns pressed state for a GuiButton or GuiObject input surface.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
