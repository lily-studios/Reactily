---
title: Reactily.useMemo
sidebar_label: useMemo
sidebar_position: 20
description: API reference for Reactily.useMemo.
---

# `Reactily.useMemo`

Memoizes a calculated value by dependency array.

## Signature
```luau
Reactily.useMemo<T>(factory: () -> T, dependencies: {any}?): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `factory` | `() -> T, dependencies: {any}?` | No | Function that calculates and returns the memoized value. |

## Returns

`T`.

## Usage
```luau
local expensive = Reactily.useMemo(function()
	return calculate(data)
end, {data})
```

## Understanding this API

Memoization avoids repeating an expensive calculation while the listed dependencies remain equal. It caches a computed value, not a Roblox Instance.

### Practical guidance

Include every changing input that the calculation reads in the dependency list. A stale dependency list can produce stale results; use a normal local computation for inexpensive work.

## Additional usage notes

### When to use it

Use `useMemo` when an expensive derived value only needs recomputation after its dependencies change.

### Behavior and ownership

A memoized value is an optimization, not a separate source of truth.

### Pitfalls to avoid

> **Note:** Do not use it in place of state for values that must independently trigger a rerender.
