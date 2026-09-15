---
title: Reactily.roundBinding
sidebar_label: roundBinding
sidebar_position: 10
description: API reference for Reactily.roundBinding.
---

# `Reactily.roundBinding`

Creates a derived numeric binding rounded to the requested decimal precision.

## Signature
```typescript
Reactily.roundBinding(source: binding<number>, precision: number): binding<number>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `binding<number>` | Yes | Source Reactily atom, binding, or signal. |
| `precision` | `number` | Yes | Number of decimal places retained by numeric rounding. |

## Returns

A `binding<number>`.

## Usage
```typescript
local rounded = Reactily.roundBinding(valueBinding, 2)
```
