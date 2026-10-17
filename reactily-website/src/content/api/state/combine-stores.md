---
title: Reactily.combineStores
sidebar_label: combineStores
sidebar_position: 3
description: API reference for Reactily.combineStores.
---

# `Reactily.combineStores`

Combines multiple stores into one derived selector.

## Signature
```luau
Reactily.combineStores<R>(stores: {Store<any>}, selectorFunction: (values: {any}) -> R): Selector<R>
```
## Usage
```luau
local combined = Reactily.combineStores(
	{firstStore, secondStore},
	function(values)
		return values[1].value + values[2].value
	end
)
```
## Works with

Pairs naturally with `createStore`, `createSelector`, `useStore`, `batch`, `patch`.

## Understanding this API

This function works with state that may be observed or manipulated independently of one component. Use it to keep application data and rendering responsibilities separate.

### Practical guidance

Keep references to shared state in a stable location instead of recreating them on every render. Use computed values and selectors for derived data, and use batched updates when several related changes should be grouped.

## Additional usage notes

### When to use it

Use this helper when combines multiple stores into one derived selector.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
