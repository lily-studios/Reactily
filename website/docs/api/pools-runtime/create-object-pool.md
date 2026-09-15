---
title: Reactily.createObjectPool
sidebar_label: createObjectPool
sidebar_position: 4
description: API reference for Reactily.createObjectPool.
---

# `Reactily.createObjectPool`

Creates a generic bounded object pool with explicit reset and final cleanup.

## Signature
```typescript
Reactily.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): objectPool<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `createObject` | `() -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number` | Yes | Function used to allocate a new pooled object when no reusable object is available. |

## Returns

A bounded `objectPool<T>`.

## Usage
```typescript
local pool = Reactily.createObjectPool(
	function()
		return {}
	end,
	table.clear,
	table.clear,
	64
)
```
