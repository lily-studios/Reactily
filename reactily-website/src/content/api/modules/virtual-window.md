---
title: Reactily.VirtualWindow
sidebar_label: VirtualWindow
sidebar_position: 33
description: Public Reactily VirtualWindow module.
---

# `Reactily.VirtualWindow`

`Reactily.VirtualWindow` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualWindow.new`

Creates a cached controller for variable-size virtualized lists.

```luau
Reactily.VirtualWindow.new(sizes: { number }, viewportSize: number, overscan: number?): variableVirtualList
```

### `VirtualWindow.resolve`

Resolves a visible range for variable-size items.

```luau
Reactily.VirtualWindow.resolve(sizes: { number }, scrollOffset: number, viewportSize: number, overscan: number?): variableRange
```
