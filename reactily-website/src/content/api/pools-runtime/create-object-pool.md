---
title: Reactily.createObjectPool
sidebar_label: createObjectPool
sidebar_position: 4
description: API reference for Reactily.createObjectPool.
---

# `Reactily.createObjectPool`

Creates a generic bounded object pool with explicit reset and final cleanup.

## Signature
```luau
Reactily.createObjectPool<T>(
	createObject: () -> T,
	resetObject: (object: T) -> (),
	deleteObject: (object: T) -> (),
	maximumSize: number
): ObjectPool<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `createObject` | `() -> T` | Yes | Allocate an object when the pool has nothing to reuse. |
| `resetObject` | `(object: T) -> ()` | Yes | Prepare an object before it returns to the available pool. |
| `deleteObject` | `(object: T) -> ()` | Yes | Perform final cleanup for discarded or deleted pooled objects. |
| `maximumSize` | `number` | Yes | Maximum number of available objects retained for reuse. |

## Returns

A bounded `ObjectPool<T>`.

## Usage
```luau
local pool = Reactily.createObjectPool(
	function()
		return {}
	end,
	table.clear,
	table.clear,
	64
)
```

## Understanding this API

A pool retains reusable values that would otherwise need to be constructed repeatedly.

### Practical guidance

Supply reset and cleanup behavior appropriate to those values. Releasing an object should prepare it for its next user; deleting the pool should dispose of retained resources.

## Additional usage notes

### When to use it

Use this creator when you need the ObjectPool capability described above, and keep its result under a clear owner.

### Behavior and ownership

Runtime helpers manage reusable objects, cleanup, and ownership details.

### Pitfalls to avoid

> **Note:** Make sure resources are returned to their owner or released when no longer needed.
