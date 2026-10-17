---
title: Reactily.createSuspense
sidebar_label: createSuspense
sidebar_position: 5
description: API reference for Reactily.createSuspense.
---

# `Reactily.createSuspense`

Creates a Suspense boundary around one child element.

## Signature
```luau
Reactily.createSuspense(fallback: Element, child: Element, key: string?): Element
```
## Usage
```luau
local boundary = Reactily.createSuspense(
	loadingFallback,
	child
)
```
## Works with

Pairs naturally with `createResource`, `lazy`, `createErrorBoundary`.

## Understanding this API

Suspense provides fallback UI while a child waits for a compatible pending resource or lazy operation.

### Practical guidance

Design the fallback for short or repeated waits. Resource handling must follow Reactily’s supported suspense behavior; ordinary `task.wait()` in arbitrary components is not equivalent.

## Additional usage notes

### When to use it

Use Suspense to display fallback elements while supported lazy/resource work is unresolved.

### Behavior and ownership

The boundary coordinates an alternative element until its children are ready.

### Pitfalls to avoid

> **Note:** Make fallback content simple and avoid triggering resource reads from that fallback.
