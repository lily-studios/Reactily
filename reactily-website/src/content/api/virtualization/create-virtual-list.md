---
title: Reactily.createVirtualList
sidebar_label: createVirtualList
sidebar_position: 3
description: API reference for Reactily.createVirtualList.
---

# `Reactily.createVirtualList`

Creates a small stateful virtual-list virtualRange controller.

## Signature
```luau
Reactily.createVirtualList(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): VirtualList
```
## Usage
```luau
local list = Reactily.createVirtualList(
	1000,
	36,
	400,
	2
)
```
## Works with

Pairs naturally with `resolveVirtualList`, `sliceVirtualList`, keyed elements.

## Understanding this API

This retains a small controller for virtual list calculations across scroll updates.

### Practical guidance

Keep the same controller while the list configuration remains relevant; pass updated offsets to calculate the visible range.

## Additional usage notes

### When to use it

Use this creator when you need the VirtualList capability described above, and keep its result under a clear owner.

### Behavior and ownership

Virtualization limits the rendered content to the portion needed for the visible region.

### Pitfalls to avoid

> **Note:** Use stable item identity when mapping virtual entries to elements to avoid unnecessary remounts.
