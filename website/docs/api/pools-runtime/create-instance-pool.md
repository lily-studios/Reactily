---
title: Reactily.createInstancePool
sidebar_label: createInstancePool
sidebar_position: 2
description: API reference for Reactily.createInstancePool.
---

# `Reactily.createInstancePool`

Creates a bounded reusable pool for Roblox Instances of one class.

## Signature
```typescript
Reactily.createInstancePool(className: string, maximumSize: number): objectPool<Instance>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `className` | `string` | Yes | Roblox Instance class name to create or pool. |
| `maximumSize` | `number` | Yes | Maximum number of released objects retained by the pool. |

## Returns

A bounded `objectPool<Instance>`.

## Usage
```typescript
local pool = Reactily.createInstancePool("Frame", 64)
local frame = pool.acquire()
pool.release(frame)
```
