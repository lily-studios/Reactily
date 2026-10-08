---
title: Reactily.useCounter
sidebar_label: useCounter
sidebar_position: 8
description: API reference for Reactily.useCounter.
---

# `Reactily.useCounter`

Provides numeric state plus increment/decrement/reset/set controls.

## Signature
```luau
Reactily.useCounter(initialValue: number?): (number, CounterControls)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `number?` | No | Initial typed value. |

## Returns

`(number, CounterControls)`.

## Usage
```luau
local count, controls = Reactily.useCounter(0)
controls.increment()
```
