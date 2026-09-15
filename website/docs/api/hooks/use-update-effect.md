---
title: Reactily.useUpdateEffect
sidebar_label: useUpdateEffect
sidebar_position: 34
description: API reference for Reactily.useUpdateEffect.
---

# `Reactily.useUpdateEffect`

Runs an effect only after the initial completed render.

## Signature
```typescript
Reactily.useUpdateEffect(callback: () -> (() -> ())?, dependencies: {any}?): ()
```
## Usage
```typescript
Reactily.useUpdateEffect(function()
	print("Updated")
end, {value})
```
## Works with

Pairs naturally with `useEffect`, `useMount`, dependency-based work.
