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
Reactily.useStore<S>(storeValue: Store<S>, selectorFunction: ((state: S) -> any)?): any
```
## Usage
```luau
local count = Reactily.useStore(
	Store,
	function(state)
		return state.count
	end
)
```
## Works with

Pairs naturally with `createStore`, `createSelector`, `combineStores`, `batch`.

## Understanding this API

This hook connects a component to an existing shared store so it can react to store changes.

### Practical guidance

Create the store outside the render function or otherwise keep its identity stable. Prefer selecting the data needed by a component rather than making every consumer depend on the whole store.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes a component to a Reactily store, optionally selecting one derived value.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
