---
title: Reactily.VirtualList
sidebar_label: virtualList
sidebar_position: 32
description: Public Reactily virtualList module.
---

# `Reactily.VirtualList`

`Reactily.VirtualList` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use this module to calculate which rows of a long list should be displayed. It does not create rows automatically; use its range results with your own renderer.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `VirtualList.resolve`

Resolves a visible range for a fixed-size virtual list.

```luau
Reactily.VirtualList.resolve( itemCount: number, itemSize: number, scrollOffset: number, viewportSize: number, overscan: number? ): VirtualRange
```

### `VirtualList.new`

Creates a small stateful virtual-list range controller.

```luau
Reactily.VirtualList.new(itemCount: number, itemSize: number, viewportSize: number, overscan: number?): VirtualList
```

### `VirtualList.slice`

Returns the items contained inside a resolved virtual range.

```luau
Reactily.VirtualList.slice<T>(items: { T }, rangeValue: VirtualRange): { T }
```

### `VirtualList.render`

Creates a virtualized vertical ScrollingFrame element for a fixed-size item list.

```luau
Reactily.VirtualList.render<T>(options: VirtualListRenderOptions<T>): Reactily.Element
```

## Notes and common mistakes

- **Input:** Give virtualization helpers stable item data and the correct visible region dimensions.
- **Common mistake:** Rendering the entire data set separately and defeating the purpose of virtualization.

