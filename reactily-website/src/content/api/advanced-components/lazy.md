---
title: Reactily.lazy
sidebar_label: lazy
sidebar_position: 7
description: API reference for Reactily.lazy.
---

# `Reactily.lazy`

Creates a component whose implementation is loaded on first render.

## Signature
```luau
Reactily.lazy<T>(loader: () -> T): T
```
## Usage
```luau
local panel = Reactily.lazy(function()
	return require(script.Parent.Panel)
end)
```
## Works with

Pairs naturally with `preloadLazy`, `createSuspense`, `createErrorBoundary`.

## Understanding this API

Lazy component loading postpones resolving a component until it is needed.

### Practical guidance

Use Suspense with an appropriate fallback for work that can be temporarily unavailable; do not rely on a lazy component being resolved synchronously.

## Additional usage notes

### When to use it

Use lazy components when construction or loading should be deferred until needed.

### Behavior and ownership

A lazy wrapper delays access to the component implementation until the supported loading path runs.

### Pitfalls to avoid

> **Note:** Provide appropriate fallback and error behavior for components that can be unavailable while loading.
