---
title: Reactily.shallowEqual
sidebar_label: shallowEqual
sidebar_position: 11
description: API reference for Reactily.shallowEqual.
---

# `Reactily.shallowEqual`

Performs a shallow key/value equality comparison between two tables.

## Signature
```typescript
Reactily.shallowEqual(first: {[any]: any}?, second: {[any]: any}?): boolean
```
## Usage
```typescript
local equal = Reactily.shallowEqual(
	previousProps,
	nextProps
)
```
## Works with

Pairs naturally with `memo`, immutable `patch`, selector comparisons.
