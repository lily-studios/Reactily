---
title: Reactily.useState
sidebar_label: useState
sidebar_position: 28
description: API reference for Reactily.useState.
---

# `Reactily.useState`

Creates typed component state and a stable setter.

## Signature
```typescript
Reactily.useState<T>(initialValue: T): (T, stateSetter<T>)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

`(T, stateSetter<T>)`.

## Usage
```typescript
local count, setCount = Reactily.useState(0)
setCount(1)
```
