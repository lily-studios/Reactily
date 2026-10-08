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
	FirstStore.Set(firstValue)
	SecondStore.Set(secondValue)
end)
```
## Works with

Pairs naturally with `createStore`, store transactions, `patch`, selectors, atoms, bindings.
