---
title: Reactily.sliceVirtualList
sidebar_label: sliceVirtualList
sidebar_position: 7
description: API reference for Reactily.sliceVirtualList.
---

# `Reactily.sliceVirtualList`

Returns the source-array entries covered by a virtual range.

## Signature
```typescript
Reactily.sliceVirtualList<T>(items: {T}, rangeValue: virtualRange): {T}
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `items` | `{T}` | Yes | Source array to slice using the virtual range. |
| `rangeValue` | `virtualRange` | Yes | Virtualized range returned by `Reactily.resolveVirtualList()`. |

## Returns

`{T}`.

## Usage
```typescript
local visibleItems = Reactily.sliceVirtualList(items, range)
```
