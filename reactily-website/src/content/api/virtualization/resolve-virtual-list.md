---
title: Reactily.resolveVirtualList
sidebar_label: resolveVirtualList
sidebar_position: 6
description: API reference for Reactily.resolveVirtualList.
---

# `Reactily.resolveVirtualList`

Calculates the visible fixed-size list range plus overscan.

## Signature
```luau
Reactily.resolveVirtualList(
	itemCount: number,
	itemSize: number,
	scrollOffset: number,
	viewportSize: number,
	overscan: number?
): VirtualRange
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `itemCount` | `number` | Yes | Total number of logical items in the virtualized list. |
| `itemSize` | `number` | Yes | Fixed pixel size of one virtual-list item. Must be greater than zero. |
| `scrollOffset` | `number` | Yes | Current scroll position in pixels. |
| `viewportSize` | `number` | Yes | Visible viewport size in pixels. |
| `overscan` | `number?` | No | Optional number of extra virtual-list rows rendered before and after the visible range. |

## Returns

A virtual-list range containing `first`, `last`, `offset`, and `totalSize`.

## Usage
```luau
local range = Reactily.resolveVirtualList(
	5000,
	44,
	scrollingFrame.CanvasPosition.Y,
	scrollingFrame.AbsoluteWindowSize.Y,
	3
)
```

## Understanding this API

Given scrolling measurements, this calculates the index range that intersects the viewport.

### Practical guidance

Use the resulting indices to mount visible rows and position them at the correct offsets inside the full scroll area.

## Additional usage notes

### When to use it

Use this helper when calculates the visible fixed-size list range plus overscan.

### Behavior and ownership

Virtualization limits the rendered content to the portion needed for the visible region.

### Pitfalls to avoid

> **Note:** Use stable item identity when mapping virtual entries to elements to avoid unnecessary remounts.
