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

## Understanding this API

Advanced component utilities change how Reactily constructs, loads, wraps, or reuses part of the virtual tree. Their behavior affects rendering and component boundaries, not the underlying Roblox Instance class directly.

### Practical guidance

Choose these only when you need their particular behavior; ordinary user interfaces can be built with typed creators and `createComponent`. Understand the component lifecycle and return type before adding wrappers.

## Additional usage notes

### When to use it

Use this for lazily obtained data that is accessed from the component/resource flow, rather than creating ad-hoc loader calls in render.

### Behavior and ownership

The resource holds its loader and exposes the resource contract. Its behavior integrates with supported Suspense flows.

### Pitfalls to avoid

> **Note:** Handle failures with the supported error-boundary flow. A resource is not a Roblox Instance and should not be parented.
