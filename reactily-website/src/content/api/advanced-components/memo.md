---
title: Reactily.memo
sidebar_label: memo
sidebar_position: 8
description: API reference for Reactily.memo.
---

# `Reactily.memo`

Wraps a component with a memoization comparator.

## Signature
```luau
Reactily.memo<T>(componentValue: T, comparator: ((previousProps: {[string]: any}, nextProps: {[string]: any}) -> boolean)?): T
```
## Usage
```luau
local optimizedComponent = Reactily.memo(Component)
```
## Works with

Pairs naturally with `shallowEqual`, selectors, immutable `patch`, context.

## Understanding this API

Memo wraps a component to skip work when the comparison reports that relevant props have not changed.

### Practical guidance

Use this for expensive children that frequently receive the same props. Incorrect comparators can hide necessary updates, so start with the default behavior and profile before optimizing.

## Additional usage notes

### When to use it

Use this wrapper to avoid unnecessary recomputation of components when their inputs have not meaningfully changed.

### Behavior and ownership

The wrapper can skip work when its equality decision says inputs are unchanged.

### Pitfalls to avoid

> **Note:** Do not rely on memoization to hide side effects inside a render function.
