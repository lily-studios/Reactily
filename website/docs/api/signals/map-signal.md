---
title: Reactily.mapSignal
sidebar_label: mapSignal
sidebar_position: 5
description: API reference for Reactily.mapSignal.
---

# `Reactily.mapSignal`

Creates a derived signal by transforming every emitted source value.

## Signature
```typescript
Reactily.mapSignal<A, B>(source: signal<A>, mapper: (value: A) -> B): signal<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `signal<A>` | Yes | Source Reactily atom, binding, or signal. |
| `mapper` | `(value: A) -> B` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `signal<B>`.

## Usage
```typescript
local labels = Reactily.mapSignal(source, function(value)
	return `Item {value}`
end)
```
