---
title: Reactily.createErrorBoundary
sidebar_label: createErrorBoundary
sidebar_position: 3
description: API reference for Reactily.createErrorBoundary.
---

# `Reactily.createErrorBoundary`

Creates an error boundary around one child element.

## Signature
```luau
Reactily.createErrorBoundary(fallback: Element | ((failure: any) -> Element), child: Element, onError: ((failure: any) -> ())?, key: string?): Element
```
## Usage
```luau
local boundary = Reactily.createErrorBoundary(
	errorFallback,
	child,
	function(failure)
		warn(failure)
	end
)
```
## Works with

Pairs naturally with `createSuspense`, `lazy`, `createResource`.

## Understanding this API

An error boundary provides fallback UI when descendant rendering fails.

### Practical guidance

It does not generally replace every Lua `pcall` around ordinary event handlers. Use a meaningful fallback and log the underlying error while developing.

## Additional usage notes

### When to use it

Use an error boundary to show fallback UI when descendant rendering fails.

### Behavior and ownership

The boundary catches supported render-time failures in its subtree.

### Pitfalls to avoid

> **Note:** Do not assume it catches every Roblox event callback or asynchronous task error.
