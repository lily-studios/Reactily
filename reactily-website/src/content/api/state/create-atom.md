---
title: Reactily.createAtom
sidebar_label: createAtom
sidebar_position: 4
description: API reference for Reactily.createAtom.
---

# `Reactily.createAtom`

Creates standalone change-only typed state.

## Signature
```luau
Reactily.createAtom<T>(initialValue: T): Atom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

An `Atom<T>` with PascalCase `Get()`, `Set()`, `Update()`, `Subscribe()`, `Delete()`, and `IsDeleted()` methods.

## Usage
```luau
local Level = Reactily.createAtom(0.7)
local Connection = Level.Subscribe(function(change: Reactily.AtomChange<number>)
    print(change.Previous, change.Current)
end)
Level.Set(0.9)
Connection.Disconnect()
Level.Delete()
```
