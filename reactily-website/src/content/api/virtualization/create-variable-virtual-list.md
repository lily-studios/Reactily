---
title: Reactily.createVariableVirtualList
sidebar_label: createVariableVirtualList
sidebar_position: 2
description: API reference for Reactily.createVariableVirtualList.
---

# `Reactily.createVariableVirtualList`

Creates a cached controller for variable-size virtualized lists.

## Signature
```luau
Reactily.createVariableVirtualList(sizes: {number}, viewportSize: number, overscan: number?): VariableVirtualList
```
## Usage
```luau
local list = Reactily.createVariableVirtualList(
	itemSizes,
	viewportSize,
	2
)
```
## Works with

Pairs naturally with `resolveVariableVirtualList`, keyed elements, scrolling containers.
