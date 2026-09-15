---
title: Reactily.resolveVariableVirtualList
sidebar_label: resolveVariableVirtualList
sidebar_position: 4
description: API reference for Reactily.resolveVariableVirtualList.
---

# `Reactily.resolveVariableVirtualList`

Resolves a visible range for variable-size items.

## Signature
```typescript
Reactily.resolveVariableVirtualList(sizes: {number}, scrollOffset: number, viewportSize: number, overscan: number?): variableVirtualRange
```
## Usage
```typescript
local range = Reactily.resolveVariableVirtualList(
	itemSizes,
	scrollOffset,
	viewportSize,
	2
)
```
## Works with

Pairs naturally with `createVariableVirtualList`, scrolling containers, keyed elements.
