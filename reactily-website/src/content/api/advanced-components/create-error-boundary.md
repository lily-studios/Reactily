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
