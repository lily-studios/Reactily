---
title: Reactily.lazy
sidebar_label: lazy
sidebar_position: 7
description: API reference for Reactily.lazy.
---

# `Reactily.lazy`

Creates a component whose implementation is loaded on first render.

## Signature
```typescript
Reactily.lazy<T>(loader: () -> T): T
```
## Usage
```typescript
local panel = Reactily.lazy(function()
	return require(script.Parent.Panel)
end)
```
## Works with

Pairs naturally with `preloadLazy`, `createSuspense`, `createErrorBoundary`.
