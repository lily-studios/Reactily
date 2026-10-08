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
