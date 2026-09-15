---
title: Reactily.createHistoryAtom
sidebar_label: createHistoryAtom
sidebar_position: 7
description: API reference for Reactily.createHistoryAtom.
---

# `Reactily.createHistoryAtom`

Creates an atom with bounded undo/redo history.

## Signature
```typescript
Reactily.createHistoryAtom<T>(initialValue: T, limit: number): historyAtom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |
| `limit` | `number` | Yes | Maximum number of undo-history entries retained. Must be greater than zero. |

## Returns

A `historyAtom<T>` with undo/redo history.

## Usage
```typescript
local position = Reactily.createHistoryAtom(Vector2.zero, 100)
position.set(Vector2.new(20, 10))
position.undo()
```
