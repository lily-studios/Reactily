---
title: Reactily.mapBinding
sidebar_label: mapBinding
sidebar_position: 9
description: API reference for Reactily.mapBinding.
---

# `Reactily.mapBinding`

Creates a derived binding by transforming the source value.

## Signature
```typescript
Reactily.mapBinding<A, B>(source: binding<A>, mapper: (value: A) -> B): binding<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `binding<A>` | Yes | Source Reactily atom, binding, or signal. |
| `mapper` | `(value: A) -> B` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `binding<B>`.

## Usage
```typescript
local percent = Reactily.mapBinding(progress, function(value)
	return value * 100
end)
```
