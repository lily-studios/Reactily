---
title: Reactily.createStore
sidebar_label: createStore
sidebar_position: 9
description: API reference for Reactily.createStore.
---

# `Reactily.createStore`

Creates structured external state with subscriptions, selectors, and batching.

## Signature
```luau
Reactily.createStore<T>(initialState: T): Store<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialState` | `T` | Yes | Initial typed state value. |

## Returns

A `Store<T>`.

## Usage
```luau
local Store = Reactily.createStore({
	page = "Home",
})
```

## Understanding this API

A store groups related state and provides update and observation behavior for larger data models.

### Practical guidance

Use a store when separate UI components need coordinated access to a common model. Prefer immutable or intentional updates so listeners can reliably distinguish changes.

## Additional usage notes

### When to use it

Use a store for structured shared state with updates, selectors, and subscriptions.

### Behavior and ownership

The store owns its state and publishes changes through its methods.

### Pitfalls to avoid

> **Note:** Prefer the documented update methods rather than mutating a retrieved state table in place.
