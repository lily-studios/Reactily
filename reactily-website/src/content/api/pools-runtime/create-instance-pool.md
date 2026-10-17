---
title: Reactily.createInstancePool
sidebar_label: createInstancePool
sidebar_position: 2
description: API reference for Reactily.createInstancePool.
---

# `Reactily.createInstancePool`

Creates a bounded reusable pool for Roblox Instances of one class.

## Signature
```luau
Reactily.createInstancePool(className: string, maximumSize: number): ObjectPool<Instance>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `className` | `string` | Yes | Roblox Instance class name to create or pool. |
| `maximumSize` | `number` | Yes | Maximum number of released objects retained by the pool. |

## Returns

A bounded `ObjectPool<Instance>`.

## Usage
```luau
local pool = Reactily.createInstancePool("Frame", 64)
local frame = pool.acquire()
pool.release(frame)
```

## Understanding this API

Instance pooling can reduce repeated Roblox Instance creation when you frequently show and hide similar objects.

### Practical guidance

Make sure a recycled Instance is reset before reuse, including properties and connections owned by its previous user.

## Additional usage notes

### When to use it

Use this creator when you need the InstancePool capability described above, and keep its result under a clear owner.

### Behavior and ownership

Runtime helpers manage reusable objects, cleanup, and ownership details.

### Pitfalls to avoid

> **Note:** Make sure resources are returned to their owner or released when no longer needed.
