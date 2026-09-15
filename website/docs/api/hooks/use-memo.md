---
title: Reactily.useMemo
sidebar_label: useMemo
sidebar_position: 20
description: API reference for Reactily.useMemo.
---

# `Reactily.useMemo`

Memoizes a calculated value by dependency array.

## Signature
```typescript
Reactily.useMemo<T>(factory: () -> T, dependencies: {any}?): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `factory` | `() -> T, dependencies: {any}?` | No | Function that calculates and returns the memoized value. |

## Returns

`T`.

## Usage
```typescript
local expensive = Reactily.useMemo(function()
	return calculate(data)
end, {data})
```
