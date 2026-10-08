---
title: Reactily.takeSignal
sidebar_label: takeSignal
sidebar_position: 8
description: API reference for Reactily.takeSignal.
---

# `Reactily.takeSignal`

Creates a derived signal that forwards at most `maximum` source emissions.

## Signature
```luau
Reactily.takeSignal<T>(source: Signal<T>, maximum: number): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `maximum` | `number` | Yes | Maximum allowed value or maximum number of signal emissions to forward. |

## Returns

A `Signal<T>`.

## Usage
```luau
local firstFive = Reactily.takeSignal(source, 5)
```
