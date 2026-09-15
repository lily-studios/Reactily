---
title: Reactily.combineBindings
sidebar_label: combineBindings
sidebar_position: 5
description: API reference for Reactily.combineBindings.
---

# `Reactily.combineBindings`

Creates a derived binding from two source bindings.

## Signature
```typescript
Reactily.combineBindings<A, B, R>(
	first: binding<A>,
	second: binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): binding<R>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `first` | `binding<A>` | Yes | First source binding. |
| `second` | `binding<B>` | Yes | Second source binding. |
| `mapper` | `(firstValue: A, secondValue: B) -> R` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `binding<R>`.

## Usage
```typescript
local point = Reactily.combineBindings(x, y, function(xValue, yValue)
	return Vector2.new(xValue, yValue)
end)
```
