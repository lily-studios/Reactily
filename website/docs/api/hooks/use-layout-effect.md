---
title: Reactily.useLayoutEffect
sidebar_label: useLayoutEffect
sidebar_position: 19
description: API reference for Reactily.useLayoutEffect.
---

# `Reactily.useLayoutEffect`

Queues an effect for the layout phase before normal effects.

## Signature
```typescript
Reactily.useLayoutEffect(callback: () -> (() -> ())?, dependencies: {any}?): ()
```
## Usage
```typescript
Reactily.useLayoutEffect(function()
	updateLayout()
end, {size})
```
## Works with

Pairs naturally with `useTween`, refs, layout-sensitive work.
