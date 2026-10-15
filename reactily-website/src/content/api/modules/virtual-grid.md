---
title: Reactily.VirtualGrid
sidebar_label: VirtualGrid
sidebar_position: 31
description: Public Reactily VirtualGrid module.
---

# `Reactily.VirtualGrid`

`Reactily.VirtualGrid` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use grid range calculation when a dataset is arranged into rows and columns rather than a single vertical list.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `VirtualGrid.resolve`

Resolves the visible item range for a fixed-size grid.

```luau
Reactily.VirtualGrid.resolve( itemCount: number, cellWidth: number, cellHeight: number, viewportWidth: number, viewportHeight: number, scrollOffsetY: number, horizontalGap: number?, verticalGap: number?, overscanRows: number? ): GridRange
```

### `VirtualGrid.render`

Creates a virtualized vertical ScrollingFrame element for a fixed-cell grid.

```luau
Reactily.VirtualGrid.render<T>(options: VirtualGridRenderOptions<T>): Reactily.Element
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

