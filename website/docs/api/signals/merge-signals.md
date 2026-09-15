---
title: Reactily.mergeSignals
sidebar_label: mergeSignals
sidebar_position: 6
description: API reference for Reactily.mergeSignals.
---

# `Reactily.mergeSignals`

Creates a derived signal that forwards emissions from all supplied sources.

## Signature
```typescript
Reactily.mergeSignals<T>(sources: {signal<T>}): signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `sources` | `{signal<T>}` | Yes | Source signals to merge into one derived signal. |

## Returns

A `signal<T>`.

## Usage
```typescript
local merged = Reactily.mergeSignals({
	firstSignal,
	secondSignal,
})
```
