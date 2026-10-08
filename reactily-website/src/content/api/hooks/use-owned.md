---
title: Reactily.useOwned
sidebar_label: useOwned
sidebar_position: 22
description: API reference for Reactily.useOwned.
---

# `Reactily.useOwned`

Registers a delete-capable object for automatic component cleanup.

## Signature
```luau
Reactily.useOwned<T>(value: T): T
```
## Usage
```luau
local Binding = Reactily.useOwned(
	Reactily.createBinding(0)
)
```
## Works with

Pairs naturally with bindings, springs, animations, diagnostics, lifecycle owners.
