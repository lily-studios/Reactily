---
title: Reactily.useImperativeHandle
sidebar_label: useImperativeHandle
sidebar_position: 17
description: API reference for Reactily.useImperativeHandle.
---

# `Reactily.useImperativeHandle`

Creates or updates an imperative handle exposed through a Reactily ref.

## Signature
```luau
Reactily.useImperativeHandle<T>(target: RefTarget<T>?, factory: () -> T, dependencies: {any}?): ()
```
## Usage
```luau
Reactily.useImperativeHandle(
	Ref,
	function()
		return {
			focus = function()
				textBox:CaptureFocus()
			end,
		}
	end,
	{}
)
```
## Works with

Pairs naturally with `forwardRef`, `useRef`, typed refs.

## Understanding this API

This hook creates or updates an imperative handle exposed through a Reactily ref. Its result belongs to the component instance, allowing Reactily to preserve the appropriate state or subscription between renders.

### Practical guidance

Call this hook at the top level of a Reactily function component, in a consistent order. Do not place hook calls inside conditionals, loops, event callbacks, or ordinary helper functions. A component may render more than once, so avoid changing Roblox instances directly during render.

## Additional usage notes

### When to use it

Use this hook when the component needs creates or updates an imperative handle exposed through a Reactily ref.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
