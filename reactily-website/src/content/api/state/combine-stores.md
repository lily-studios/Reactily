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
