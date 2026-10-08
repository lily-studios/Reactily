---
title: Reactily.VirtualList
sidebar_label: virtualList
sidebar_position: 32
description: Public Reactily virtualList module.
---

# `Reactily.VirtualList`

`Reactily.VirtualList` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualList.Resolve`

Resolves a visible range for a fixed-size virtual list.

```luau
Reactily.VirtualList.Resolve( itemCount: number, itemSize: number, scrollOffset: number, viewportSize: number, overscan: number? ): VirtualRange
```

### `VirtualList.New`

Creates a small stateful virtual-list range controller.

```luau
Reactily.VirtualList.New(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): VirtualList
```

### `VirtualList.Slice`

Returns the items contained inside a resolved virtual range.

```luau
Reactily.VirtualList.Slice<T>(items: { T }, rangeValue: VirtualRange): { T }
```

### `VirtualList.Render`

Creates a virtualized vertical ScrollingFrame element for a fixed-size item list.

```luau
Reactily.VirtualList.Render<T>(options: VirtualListRenderOptions<T>): Reactily.Element
```
