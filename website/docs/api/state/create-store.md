---
title: Reactily.createStore
sidebar_label: createStore
sidebar_position: 9
description: API reference for Reactily.createStore.
---

# `Reactily.createStore`

Creates structured external state with subscriptions, selectors, and batching.

## Signature
```typescript
Reactily.createStore<T>(initialState: T): store<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialState` | `T` | Yes | Initial typed state value. |

## Returns

A `store<T>`.

## Usage
```typescript
local store = Reactily.createStore({
	page = "Home",
})
```
