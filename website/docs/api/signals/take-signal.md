---
title: Reactily.takeSignal
sidebar_label: takeSignal
sidebar_position: 8
description: API reference for Reactily.takeSignal.
---

# `Reactily.takeSignal`

Creates a derived signal that forwards at most `maximum` source emissions.

## Signature
```typescript
Reactily.takeSignal<T>(source: signal<T>, maximum: number): signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `maximum` | `number` | Yes | Maximum allowed value or maximum number of signal emissions to forward. |

## Returns

A `signal<T>`.

## Usage
```typescript
local firstFive = Reactily.takeSignal(source, 5)
```
