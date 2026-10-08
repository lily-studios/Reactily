---
title: Reactily.VirtualGrid
sidebar_label: VirtualGrid
sidebar_position: 31
description: Public Reactily VirtualGrid module.
---

# `Reactily.VirtualGrid`

`Reactily.VirtualGrid` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualGrid.resolve`

Resolves the visible item range for a fixed-size grid.

```luau
Reactily.VirtualGrid.resolve( itemCount: number, cellWidth: number, cellHeight: number, viewportWidth: number, viewportHeight: number, scrollOffsetY: number, horizontalGap: number?, verticalGap: number?, overscanRows: number? ): gridRange
```

### `VirtualGrid.render`

Creates a virtualized vertical ScrollingFrame element for a fixed-cell grid.

```luau
Reactily.VirtualGrid.render<T>(options: renderOptions<T>): elementModule.element
```
