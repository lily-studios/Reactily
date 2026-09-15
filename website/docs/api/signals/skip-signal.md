---
title: Reactily.skipSignal
sidebar_label: skipSignal
sidebar_position: 7
description: API reference for Reactily.skipSignal.
---

# `Reactily.skipSignal`

Creates a derived signal that ignores the first `amount` source emissions.

## Signature
```typescript
Reactily.skipSignal<T>(source: signal<T>, amount: number): signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `amount` | `number` | Yes | Number of source emissions to skip, decrement by, or otherwise apply as the requested amount. |

## Returns

A `signal<T>`.

## Usage
```typescript
local afterWarmup = Reactily.skipSignal(source, 2)
```
