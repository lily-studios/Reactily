---
title: Reactily.useLayoutEffect
sidebar_label: useLayoutEffect
sidebar_position: 19
description: API reference for Reactily.useLayoutEffect.
---

# `Reactily.useLayoutEffect`

Queues an effect for the layout phase before normal effects.

## Signature
```luau
Reactily.useLayoutEffect(callback: () -> (() -> ())?, dependencies: {any}?): ()
```
## Usage
```luau
Reactily.useLayoutEffect(function()
	updateLayout()
end, {size})
```
## Works with

Pairs naturally with `useTween`, refs, layout-sensitive work.

## Understanding this API

Use a layout effect for work that needs to coordinate with mounted UI layout, such as reading a GUI object after it has been rendered.

### Practical guidance

Do not use layout effects for ordinary derived values; calculation during render or `useMemo` is usually simpler. Release event connections or observers using the effect cleanup function.

## Additional usage notes

### When to use it

Use this hook when the component needs queues an effect for the layout phase before normal effects.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
