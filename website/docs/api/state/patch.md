---
title: Reactily.patch
sidebar_label: patch
sidebar_position: 10
description: API reference for Reactily.patch.
---

# `Reactily.patch`

Returns a shallow clone with the supplied fields replaced.

## Signature
```typescript
Reactily.patch<T>(source: T, changes: {[any]: any}): T
```
## Usage
```typescript
local nextState = Reactily.patch(previousState, {
	page = "Settings",
})
```
## Works with

Pairs naturally with `createStore`, `batch`, selectors, memoized components.
