---
title: Reactily.VirtualWindow
sidebar_label: VirtualWindow
sidebar_position: 33
description: Public Reactily VirtualWindow module.
---

# `Reactily.VirtualWindow`

`Reactily.VirtualWindow` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualWindow.New`

Creates a cached controller for variable-size virtualized lists.

```luau
Reactily.VirtualWindow.New(sizes: { number }, viewportSize: number, overscan: number?): VariableVirtualList
```

### `VirtualWindow.Resolve`

Resolves a visible range for variable-size items.

```luau
Reactily.VirtualWindow.Resolve(sizes: { number }, scrollOffset: number, viewportSize: number, overscan: number?): VariableVirtualRange
```
