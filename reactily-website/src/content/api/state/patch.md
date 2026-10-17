---
title: Reactily.patch
sidebar_label: patch
sidebar_position: 10
description: API reference for Reactily.patch.
---

# `Reactily.patch`

Returns a shallow clone with the supplied fields replaced.

## Signature
```luau
Reactily.patch<T>(source: T, changes: {[any]: any}): T
```
## Usage
```luau
local nextState = Reactily.patch(previousState, {
	page = "Settings",
})
```
## Works with

Pairs naturally with `createStore`, `batch`, selectors, memoized components.

## Understanding this API

This function works with state that may be observed or manipulated independently of one component. Use it to keep application data and rendering responsibilities separate.

### Practical guidance

Keep references to shared state in a stable location instead of recreating them on every render. Use computed values and selectors for derived data, and use batched updates when several related changes should be grouped.

## Additional usage notes

### When to use it

Use this helper when returns a shallow clone with the supplied fields replaced.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
