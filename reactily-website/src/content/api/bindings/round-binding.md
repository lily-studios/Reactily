---
title: Reactily.roundBinding
sidebar_label: roundBinding
sidebar_position: 10
description: API reference for Reactily.roundBinding.
---

# `Reactily.roundBinding`

Creates a derived numeric binding rounded to the requested decimal precision.

## Signature
```luau
Reactily.roundBinding(source: Binding<number>, precision: number): Binding<number>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<number>` | Yes | Source Reactily atom, binding, or signal. |
| `precision` | `number` | Yes | Number of decimal places retained by numeric rounding. |

## Returns

A `Binding<number>`.

## Usage
```luau
local rounded = Reactily.roundBinding(valueBinding, 2)
```
