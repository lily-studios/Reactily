---
title: Reactily.useExternalStore
sidebar_label: useExternalStore
sidebar_position: 13
description: API reference for Reactily.useExternalStore.
---

# `Reactily.useExternalStore`

Subscribes a component to any external store contract.

## Signature
```typescript
Reactily.useExternalStore<T>(subscribe: (callback: () -> ()) -> (() -> ()), getSnapshot: () -> T): T
```
## Usage
```typescript
local value = Reactily.useExternalStore(
	subscribe,
	getSnapshot
)
```
## Works with

Pairs naturally with external signals/stores, lifecycle cleanup, `useEvent`.
