---
title: Reactily.resolveVirtualGrid
sidebar_label: resolveVirtualGrid
sidebar_position: 5
description: API reference for Reactily.resolveVirtualGrid.
---

# `Reactily.resolveVirtualGrid`

Resolves the visible item range for a fixed-size grid.

## Signature
```typescript
Reactily.resolveVirtualGrid(itemCount: number, cellWidth: number, cellHeight: number, viewportWidth: number, viewportHeight: number, scrollOffsetY: number, horizontalGap: number?, verticalGap: number?, overscanRows: number?): gridRange
```
## Usage
```typescript
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
