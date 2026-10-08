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
