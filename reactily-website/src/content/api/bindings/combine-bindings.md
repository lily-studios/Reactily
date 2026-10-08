---
title: Reactily.combineBindings
sidebar_label: combineBindings
sidebar_position: 5
description: API reference for Reactily.combineBindings.
---

# `Reactily.combineBindings`

Creates a derived binding from two source bindings.

## Signature
```luau
Reactily.combineBindings<A, B, R>(
	first: Binding<A>,
	second: Binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): Binding<R>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `first` | `Binding<A>` | Yes | First source binding. |
| `second` | `Binding<B>` | Yes | Second source binding. |
| `mapper` | `(firstValue: A, secondValue: B) -> R` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `Binding<R>`.

## Usage
```luau
local point = Reactily.combineBindings(x, y, function(xValue, yValue)
	return Vector2.new(xValue, yValue)
end)
```
