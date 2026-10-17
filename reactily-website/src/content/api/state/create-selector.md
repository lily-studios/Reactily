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

## Understanding this API

A selector lets consumers observe a useful projection of larger state instead of coupling to every property in a store.

### Practical guidance

Pick a result that corresponds to the component’s actual needs; overly broad selection can cause unnecessary updates.

## Additional usage notes

### When to use it

Use this creator when you need the Selector capability described above, and keep its result under a clear owner.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
