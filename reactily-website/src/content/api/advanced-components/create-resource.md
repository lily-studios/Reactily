---
title: Reactily.createResource
sidebar_label: createResource
sidebar_position: 4
description: API reference for Reactily.createResource.
---

# `Reactily.createResource`

Creates a lazy resource whose loader runs only when first requested.

## Signature
```luau
Reactily.createResource<T>(loader: () -> T): Resource<T>
```
## Usage
```luau
local Resource = Reactily.createResource(function()
	return loadData()
end)
```
## Works with

Pairs naturally with `createSuspense`, `createErrorBoundary`, lazy asynchronous UI.
