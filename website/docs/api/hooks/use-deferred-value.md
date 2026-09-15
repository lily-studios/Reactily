---
title: Reactily.useDeferredValue
sidebar_label: useDeferredValue
sidebar_position: 10
description: API reference for Reactily.useDeferredValue.
---

# `Reactily.useDeferredValue`

Returns a deferred copy of a changing value using one-shot scheduling.

## Signature
```typescript
Reactily.useDeferredValue<T>(value: T): T
```
## Usage
```typescript
local deferredValue = Reactily.useDeferredValue(value)
```
## Works with

Pairs naturally with `useTransition`, stores, search/filter UIs.
