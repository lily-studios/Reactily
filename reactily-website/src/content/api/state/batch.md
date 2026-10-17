---
title: Reactily.batch
sidebar_label: batch
sidebar_position: 2
description: API reference for Reactily.batch.
---

# `Reactily.batch`

Runs a callback inside a nested-safe global Reactily batch. Store and atom handles use PascalCase methods.

## Signature
```luau
Reactily.batch(callback: () -> ()): ()
```
## Usage
```luau
Reactily.batch(function()
	FirstStore.set(firstValue)
	SecondStore.set(secondValue)
end)
```
## Works with

Pairs naturally with `createStore`, store transactions, `patch`, selectors, atoms, bindings.

## Understanding this API

This function works with state that may be observed or manipulated independently of one component. Use it to keep application data and rendering responsibilities separate.

### Practical guidance

Keep references to shared state in a stable location instead of recreating them on every render. Use computed values and selectors for derived data, and use batched updates when several related changes should be grouped.

## Additional usage notes

### When to use it

Use this helper when runs a callback inside a nested-safe global Reactily batch. Store and atom handles use PascalCase methods.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
