---
title: Reactily.filterSignal
sidebar_label: filterSignal
sidebar_position: 4
description: API reference for Reactily.filterSignal.
---

# `Reactily.filterSignal`

Creates a derived signal that forwards only values accepted by `predicate`.

## Signature
```typescript
Reactily.filterSignal<T>(source: signal<T>, predicate: (value: T) -> boolean): signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `predicate` | `(value: T) -> boolean` | Yes | Function returning `true` when a signal value should be forwarded. |

## Returns

A `signal<T>`.

## Usage
```typescript
local even = Reactily.filterSignal(source, function(value)
	return value % 2 == 0
end)
```
