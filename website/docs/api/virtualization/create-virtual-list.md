---
title: Reactily.createVirtualList
sidebar_label: createVirtualList
sidebar_position: 3
description: API reference for Reactily.createVirtualList.
---

# `Reactily.createVirtualList`

Creates a small stateful virtual-list virtualRange controller.

## Signature
```typescript
Reactily.createVirtualList(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): virtualList
```
## Usage
```typescript
local list = Reactily.createVirtualList(
	1000,
	36,
	400,
	2
)
```
## Works with

Pairs naturally with `resolveVirtualList`, `sliceVirtualList`, keyed elements.
