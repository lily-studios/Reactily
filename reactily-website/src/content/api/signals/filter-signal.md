---
title: Reactily.filterSignal
sidebar_label: filterSignal
sidebar_position: 4
description: API reference for Reactily.filterSignal.
---

# `Reactily.filterSignal`

Creates a derived signal that forwards only values accepted by `predicate`.

## Signature
```luau
Reactily.filterSignal<T>(source: Signal<T>, predicate: (value: T) -> boolean): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `predicate` | `(value: T) -> boolean` | Yes | Function returning `true` when a signal value should be forwarded. |

## Returns

A `Signal<T>`.

## Usage
```luau
local even = Reactily.filterSignal(source, function(value)
	return value % 2 == 0
end)
```
