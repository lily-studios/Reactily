---
title: Reactily.combineStores
sidebar_label: combineStores
sidebar_position: 3
description: API reference for Reactily.combineStores.
---

# `Reactily.combineStores`

Combines multiple stores into one derived selector.

## Signature
```typescript
Reactily.combineStores<R>(stores: {store<any>}, selectorFunction: (values: {any}) -> R): selector<R>
```
## Usage
```typescript
local combined = Reactily.combineStores(
	{firstStore, secondStore},
	function(values)
		return values[1].value + values[2].value
	end
)
```
## Works with

Pairs naturally with `createStore`, `createSelector`, `useStore`, `batch`, `patch`.
