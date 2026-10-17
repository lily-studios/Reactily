---
title: Reactily.createComputed
sidebar_label: createComputed
sidebar_position: 6
description: API reference for Reactily.createComputed.
---

# `Reactily.createComputed`

Creates read-only derived atom state from a source atom.

## Signature
```luau
Reactily.createComputed<A, B>(
	source: Atom<A>,
	selectorFunction: (value: A) -> B
): Computed<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Atom<A>` | Yes | Source Reactily atom, binding, or signal. |
| `selectorFunction` | `(value: A) -> B` | Yes | Function that derives a selected/computed value from the source. |

## Returns

A read-only derived `Computed<B>`.

## Usage
```luau
local label = Reactily.createComputed(level, function(value)
	return string.format("%.2f Level", value)
end)
```

## Understanding this API

A computed value derives its result from other reactive state instead of duplicating that result as manually synchronized state.

### Practical guidance

Use computed data for totals, labels, or filtered views that can be recalculated from the source values.

## Additional usage notes

### When to use it

Use this creator when you need the Computed capability described above, and keep its result under a clear owner.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
