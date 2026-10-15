---
title: Reactily.useCallback
sidebar_label: useCallback
sidebar_position: 5
description: API reference for Reactily.useCallback.
---

# `Reactily.useCallback`

Memoizes a callback/value by dependency array.

## Signature
```luau
Reactily.useCallback<T>(callback: T, dependencies: {any}?): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `callback` | `T` | Yes | Function Reactily calls for the operation, subscription, effect, batch, scheduled task, or event. |
| `dependencies` | `{any}?` | No | Dependency array used to decide whether the memo, callback, or effect should update. `nil` means it is treated as changed every render. |

## Returns

`T`.

## Usage
```luau
local OnClick = Reactily.useCallback(function()
	print(selection)
end, {selection})
```

## Understanding this API

Use this when a callback should retain its identity between renders, for example when passing it into a memoized child component.

### Practical guidance

`useCallback` does not itself prevent every rerender. It only stabilizes the callback reference while dependencies remain unchanged.

## Additional usage notes

### When to use it

Use this hook when the component needs memoizes a callback/value by dependency array.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
