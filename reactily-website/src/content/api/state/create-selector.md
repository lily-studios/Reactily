---
title: Reactily.createSelector
sidebar_label: createSelector
sidebar_position: 8
description: API reference for Reactily.createSelector.
---

# `Reactily.createSelector`

Creates a derived selector from one store.

## Signature
```luau
Reactily.createSelector<T, R>(source: store<T>, selectorFunction: (state: T) -> R): selector<R>
```
## Usage
```luau
local selector = Reactily.createSelector(
	store,
	function(state)
		return state.count
	end
)
```
## Works with

Pairs naturally with `createStore`, `combineStores`, `useStore`, `memo`.
