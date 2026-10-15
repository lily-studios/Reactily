---
title: Reactily.resolveVirtualGrid
sidebar_label: resolveVirtualGrid
sidebar_position: 5
description: API reference for Reactily.resolveVirtualGrid.
---

# `Reactily.resolveVirtualGrid`

Resolves the visible item range for a fixed-size grid.

## Signature
```luau
Reactily.resolveVirtualGrid(itemCount: number, cellWidth: number, cellHeight: number, viewportWidth: number, viewportHeight: number, scrollOffsetY: number, horizontalGap: number?, verticalGap: number?, overscanRows: number?): GridRange
```
## Usage
```luau
local range = Reactily.resolveVirtualGrid(
	500,
	120,
	48,
	600,
	400,
	scrollOffsetY,
	8,
	8,
	2
)
```
## Works with

Pairs naturally with grid UI, keyed children, fixed-cell virtualization.

## Understanding this API

A grid resolver calculates the visible cells within a two-dimensional viewport.

### Practical guidance

Account for row and column dimensions when mapping the returned visible range back into dataset indexes.

## Additional usage notes

### When to use it

Use this helper when resolves the visible item range for a fixed-size grid.

### Behavior and ownership

Virtualization limits the rendered content to the portion needed for the visible region.

### Pitfalls to avoid

> **Note:** Use stable item identity when mapping virtual entries to elements to avoid unnecessary remounts.
