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
