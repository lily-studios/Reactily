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
Reactily.createSelector<T, R>(source: Store<T>, selectorFunction: (state: T) -> R): Selector<R>
```
## Usage
```luau
local Selector = Reactily.createSelector(
	Store,
	function(state)
		return state.count
	end
)
```
## Works with

Pairs naturally with `createStore`, `combineStores`, `useStore`, `memo`.
