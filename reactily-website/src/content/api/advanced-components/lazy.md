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
