---
title: Reactily.createErrorBoundary
sidebar_label: createErrorBoundary
sidebar_position: 3
description: API reference for Reactily.createErrorBoundary.
---

# `Reactily.createErrorBoundary`

Creates an error boundary around one child element.

## Signature
```typescript
Reactily.createErrorBoundary(fallback: element | ((failure: any) -> element), child: element, onError: ((failure: any) -> ())?, key: string?): element
```
## Usage
```typescript
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
