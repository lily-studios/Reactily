---
title: Reactily.VirtualGrid
sidebar_label: VirtualGrid
sidebar_position: 31
description: Public Reactily VirtualGrid module.
---

# `Reactily.VirtualGrid`

`Reactily.VirtualGrid` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualGrid.Resolve`

Resolves the visible item range for a fixed-size grid.

```luau
Reactily.VirtualGrid.Resolve( itemCount: number, cellWidth: number, cellHeight: number, viewportWidth: number, viewportHeight: number, scrollOffsetY: number, horizontalGap: number?, verticalGap: number?, overscanRows: number? ): GridRange
```

### `VirtualGrid.Render`

Creates a virtualized vertical ScrollingFrame element for a fixed-cell grid.

```luau
Reactily.VirtualGrid.Render<T>(options: VirtualGridRenderOptions<T>): Reactily.Element
```
