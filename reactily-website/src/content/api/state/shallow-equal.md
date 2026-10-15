---
title: Reactily.shallowEqual
sidebar_label: shallowEqual
sidebar_position: 11
description: API reference for Reactily.shallowEqual.
---

# `Reactily.shallowEqual`

Performs a shallow key/value equality comparison between two tables.

## Signature
```luau
Reactily.shallowEqual(first: {[any]: any}?, second: {[any]: any}?): boolean
```
## Usage
```luau
local equal = Reactily.shallowEqual(
	previousProps,
	nextProps
)
```
## Works with

Pairs naturally with `memo`, immutable `patch`, selector comparisons.

## Understanding this API

This function works with state that may be observed or manipulated independently of one component. Use it to keep application data and rendering responsibilities separate.

### Practical guidance

Keep references to shared state in a stable location instead of recreating them on every render. Use computed values and selectors for derived data, and use batched updates when several related changes should be grouped.

## Additional usage notes

### When to use it

Use this helper when performs a shallow key/value equality comparison between two tables.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
