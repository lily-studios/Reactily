---
title: Reactily.createHistoryAtom
sidebar_label: createHistoryAtom
sidebar_position: 7
description: API reference for Reactily.createHistoryAtom.
---

# `Reactily.createHistoryAtom`

Creates an atom with bounded undo/redo history.

## Signature
```luau
Reactily.createHistoryAtom<T>(initialValue: T, limit: number): HistoryAtom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |
| `limit` | `number` | Yes | Maximum number of undo-history entries retained. Must be greater than zero. |

## Returns

A `HistoryAtom<T>` with undo/redo history.

## Usage
```luau
local Position = Reactily.createHistoryAtom(Vector2.zero, 100)
Position.set(Vector2.new(20, 10))
Position.Undo()
```

## Understanding this API

A history atom records a sequence of state changes so previous values can be revisited through undo/redo behavior.

### Practical guidance

Use it for editor-like interactions where reversing changes is meaningful. Large snapshots may carry a memory cost, so only store the state you actually need to restore.

## Additional usage notes

### When to use it

Use this creator when you need the HistoryAtom capability described above, and keep its result under a clear owner.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
