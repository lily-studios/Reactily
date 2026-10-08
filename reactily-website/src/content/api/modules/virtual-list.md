---
title: Reactily.VirtualList
sidebar_label: virtualList
sidebar_position: 32
description: Public Reactily virtualList module.
---

# `Reactily.VirtualList`

`Reactily.VirtualList` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `VirtualList.resolve`

Resolves a visible range for a fixed-size virtual list.

```luau
Reactily.VirtualList.resolve( itemCount: number, itemSize: number, scrollOffset: number, viewportSize: number, overscan: number? ): range
```

### `VirtualList.new`

Creates a small stateful virtual-list range controller.

```luau
Reactily.VirtualList.new(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): VirtualList
```

### `VirtualList.slice`

Returns the items contained inside a resolved virtual range.

```luau
Reactily.VirtualList.slice<T>(items: { T }, rangeValue: range): { T }
```

### `VirtualList.render`

Creates a virtualized vertical ScrollingFrame element for a fixed-size item list.

```luau
Reactily.VirtualList.render<T>(options: renderOptions<T>): elementModule.Element
```
