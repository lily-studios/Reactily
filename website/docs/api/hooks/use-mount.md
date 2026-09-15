---
title: Reactily.useMount
sidebar_label: useMount
sidebar_position: 21
description: API reference for Reactily.useMount.
---

# `Reactily.useMount`

Runs an effect once when the component mounts.

## Signature
```typescript
Reactily.useMount(callback: () -> (() -> ())?): ()
```
## Usage
```typescript
Reactily.useMount(function()
	print("Mounted")
end)
```
## Works with

Pairs naturally with `useUnmount`, `useOwned`, subscriptions.
