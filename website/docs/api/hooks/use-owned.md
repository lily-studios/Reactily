---
title: Reactily.useOwned
sidebar_label: useOwned
sidebar_position: 22
description: API reference for Reactily.useOwned.
---

# `Reactily.useOwned`

Registers a delete-capable object for automatic component cleanup.

## Signature
```typescript
Reactily.useOwned<T>(value: T): T
```
## Usage
```typescript
local binding = Reactily.useOwned(
	Reactily.createBinding(0)
)
```
## Works with

Pairs naturally with bindings, springs, animations, diagnostics, lifecycle owners.
