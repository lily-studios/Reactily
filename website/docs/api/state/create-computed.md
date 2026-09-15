---
title: Reactily.createComputed
sidebar_label: createComputed
sidebar_position: 6
description: API reference for Reactily.createComputed.
---

# `Reactily.createComputed`

Creates read-only derived atom state from a source atom.

## Signature
```typescript
Reactily.createComputed<A, B>(
	source: atom<A>,
	selectorFunction: (value: A) -> B
): computed<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `atom<A>` | Yes | Source Reactily atom, binding, or signal. |
| `selectorFunction` | `(value: A) -> B` | Yes | Function that derives a selected/computed value from the source. |

## Returns

A read-only derived `computed<B>`.

## Usage
```typescript
local label = Reactily.createComputed(level, function(value)
	return string.format("%.2f Level", value)
end)
```
