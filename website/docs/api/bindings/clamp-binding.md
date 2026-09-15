---
title: Reactily.clampBinding
sidebar_label: clampBinding
sidebar_position: 4
description: API reference for Reactily.clampBinding.
---

# `Reactily.clampBinding`

Creates a derived numeric binding clamped between `minimum` and `maximum`.

## Signature
```typescript
Reactily.clampBinding(
	source: binding<number>,
	minimum: number,
	maximum: number
): binding<number>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `binding<number>` | Yes | Source Reactily atom, binding, or signal. |
| `minimum` | `number` | Yes | Minimum allowed numeric value. |
| `maximum` | `number` | Yes | Maximum allowed value or maximum number of signal emissions to forward. |

## Returns

A `binding<number>`.

## Usage
```typescript
local safeProgress = Reactily.clampBinding(progress, 0, 1)
```
