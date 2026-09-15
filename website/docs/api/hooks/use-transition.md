---
title: Reactily.useTransition
sidebar_label: useTransition
sidebar_position: 31
description: API reference for Reactily.useTransition.
---

# `Reactily.useTransition`

Creates a low-priority transition starter and pending state.

## Signature
```typescript
Reactily.useTransition(): (boolean, transitionStarter)
```
## Usage
```typescript
local isPending, startTransition = Reactily.useTransition()

startTransition(function()
	updateState()
end)
```
## Works with

Pairs naturally with `startTransition`, `useDeferredValue`, stores.
