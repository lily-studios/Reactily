---
title: Reactily.useStore
sidebar_label: useStore
sidebar_position: 29
description: API reference for Reactily.useStore.
---

# `Reactily.useStore`

Subscribes a component to a Reactily store, optionally selecting one derived value.

## Signature
```luau
Reactily.useStore<S>(storeValue: store<S>, selectorFunction: ((state: S) -> any)?): any
```
## Usage
```luau
local count = Reactily.useStore(
	store,
	function(state)
		return state.count
	end
)
```
## Works with

Pairs naturally with `createStore`, `createSelector`, `combineStores`, `batch`.
