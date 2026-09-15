---
title: Reactily.distinctSignal
sidebar_label: distinctSignal
sidebar_position: 3
description: API reference for Reactily.distinctSignal.
---

# `Reactily.distinctSignal`

Creates a derived signal that suppresses consecutive duplicate values.

## Signature
```typescript
Reactily.distinctSignal<T>(source: signal<T>): signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `signal<T>` | Yes | Source Reactily atom, binding, or signal. |

## Returns

A `signal<T>`.

## Usage
```typescript
local unique = Reactily.distinctSignal(source)
```
