---
title: Reactily.resolveVariableVirtualList
sidebar_label: resolveVariableVirtualList
sidebar_position: 4
description: API reference for Reactily.resolveVariableVirtualList.
---

# `Reactily.resolveVariableVirtualList`

Resolves a visible range for variable-size items.

## Signature
```luau
Reactily.resolveVariableVirtualList(sizes: {number}, scrollOffset: number, viewportSize: number, overscan: number?): VariableVirtualRange
```
## Usage
```luau
local range = Reactily.resolveVariableVirtualList(
	itemSizes,
	scrollOffset,
	viewportSize,
	2
)
```
## Works with

Pairs naturally with `createVariableVirtualList`, scrolling containers, keyed elements.

## Understanding this API

This operation calculates or maintains a viewport-aware slice of list or grid data. It is a data/layout helper rather than a self-rendering scrolling GUI.

### Practical guidance

These APIs do not automatically create a scrolling interface. The caller remains responsible for supplying item count and dimensions, tracking scroll offsets, and rendering the calculated visible items at the correct positions.

## Additional usage notes

### When to use it

Use this helper when resolves a visible range for variable-size items.

### Behavior and ownership

Virtualization limits the rendered content to the portion needed for the visible region.

### Pitfalls to avoid

> **Note:** Use stable item identity when mapping virtual entries to elements to avoid unnecessary remounts.
