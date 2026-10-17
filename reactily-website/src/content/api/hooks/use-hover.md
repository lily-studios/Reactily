---
title: Reactily.useHover
sidebar_label: useHover
sidebar_position: 15
description: API reference for Reactily.useHover.
---

# `Reactily.useHover`

Returns hover state for a GuiObject.

## Signature
```luau
Reactily.useHover(object: GuiObject): boolean
```
## Usage
```luau
local isHovered = Reactily.useHover(button)
```
## Works with

Pairs naturally with `usePressed`, styles, interactive GuiObjects.

## Understanding this API

This hook returns hover state for a GuiObject. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs returns hover state for a GuiObject.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
