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

## Understanding this API

Unlike fixed-size virtualization, this controller handles items with different heights or widths.

### Practical guidance

Keep item-size data accurate when content changes, otherwise the calculated visible range and scroll offsets can drift.

## Additional usage notes

### When to use it

Use this creator when you need the VariableVirtualList capability described above, and keep its result under a clear owner.

### Behavior and ownership

Virtualization limits the rendered content to the portion needed for the visible region.

### Pitfalls to avoid

> **Note:** Use stable item identity when mapping virtual entries to elements to avoid unnecessary remounts.
