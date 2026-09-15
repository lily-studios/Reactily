---
title: Reactily.useCounter
sidebar_label: useCounter
sidebar_position: 8
description: API reference for Reactily.useCounter.
---

# `Reactily.useCounter`

Provides numeric state plus increment/decrement/reset/set controls.

## Signature
```typescript
Reactily.useCounter(initialValue: number?): (number, counterControls)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `number?` | No | Initial typed value. |

## Returns

`(number, counterControls)`.

## Usage
```typescript
local count, controls = Reactily.useCounter(0)
controls.increment()
```
