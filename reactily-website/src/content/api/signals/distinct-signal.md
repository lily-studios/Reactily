---
title: Reactily.distinctSignal
sidebar_label: distinctSignal
sidebar_position: 3
description: API reference for Reactily.distinctSignal.
---

# `Reactily.distinctSignal`

Creates a derived signal that suppresses consecutive duplicate values.

## Signature
```luau
Reactily.distinctSignal<T>(source: Signal<T>): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |

## Returns

A `Signal<T>`.

## Usage
```luau
local unique = Reactily.distinctSignal(source)
```
