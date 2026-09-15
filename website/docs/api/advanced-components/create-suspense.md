---
title: Reactily.createSuspense
sidebar_label: createSuspense
sidebar_position: 5
description: API reference for Reactily.createSuspense.
---

# `Reactily.createSuspense`

Creates a Suspense boundary around one child element.

## Signature
```typescript
Reactily.createSuspense(fallback: element, child: element, key: string?): element
```
## Usage
```typescript
local boundary = Reactily.createSuspense(
	loadingFallback,
	child
)
```
## Works with

Pairs naturally with `createResource`, `lazy`, `createErrorBoundary`.
