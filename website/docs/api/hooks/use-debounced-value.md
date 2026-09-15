---
title: Reactily.useDebouncedValue
sidebar_label: useDebouncedValue
sidebar_position: 9
description: API reference for Reactily.useDebouncedValue.
---

# `Reactily.useDebouncedValue`

Returns a value that updates after the requested one-shot delay.

## Signature
```typescript
Reactily.useDebouncedValue<T>(value: T, delaySeconds: number): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `value` | `T` | Yes | Typed value passed to the hook/helper. |
| `delaySeconds` | `number` | Yes | One-shot debounce delay in seconds. Must be non-negative. |

## Returns

`T`.

## Usage
```typescript
local debouncedQuery = Reactily.useDebouncedValue(query, .2)
```
