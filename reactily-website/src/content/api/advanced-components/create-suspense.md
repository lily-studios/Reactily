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
