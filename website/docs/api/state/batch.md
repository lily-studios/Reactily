---
title: Reactily.batch
sidebar_label: batch
sidebar_position: 2
description: API reference for Reactily.batch.
---

# `Reactily.batch`

Runs a callback inside a nested-safe global Reactily batch.

## Signature
```typescript
Reactily.batch(callback: () -> ()): ()
```
## Usage
```typescript
Reactily.batch(function()
	firstStore.set(firstValue)
	secondStore.set(secondValue)
end)
```
## Works with

Pairs naturally with `createStore`, store transactions, `patch`, selectors, atoms, bindings.
