---
title: Reactily.useUnmount
sidebar_label: useUnmount
sidebar_position: 33
description: API reference for Reactily.useUnmount.
---

# `Reactily.useUnmount`

Registers cleanup that runs only when the component unmounts.

## Signature
```typescript
Reactily.useUnmount(callback: () -> ()): ()
```
## Usage
```typescript
Reactily.useUnmount(function()
	print("Unmounted")
end)
```
## Works with

Pairs naturally with `useMount`, `useOwned`, effect cleanup.
