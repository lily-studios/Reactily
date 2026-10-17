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

An `Atom<T>` with camelCase `get()`, `set()`, `update()`, `subscribe()`, `delete()`, and `isDeleted()` methods.

## Usage
```luau
local Level = Reactily.createAtom(0.7)
local Connection = Level.subscribe(function(change: Reactily.AtomChange<number>)
    print(change.previous, change.current)
end)
Level.set(0.9)
Connection.disconnect()
Level.delete()
```

## Understanding this API

An atom represents one writable value outside the component-local hook state. Other code can subscribe to changes.

### Practical guidance

Use it for small pieces of shared data. Keep a single atom instance for each logical value; recreating an atom loses its earlier subscriptions and state.

## Additional usage notes

### When to use it

Use an atom when a small value needs to be shared outside any one component.

### Behavior and ownership

Subscribers observe changes through the atom’s own API, independently of component-local `useState`.

### Pitfalls to avoid

> **Note:** Store the returned atom in a stable module or owner; recreating it discards subscriptions and the existing value.
