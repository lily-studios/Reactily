---
title: Reactily.Layout
sidebar_label: Layout
sidebar_position: 14
description: Public Reactily Layout module.
---

# `Reactily.Layout`

`Reactily.Layout` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Layout.Horizontal`

Creates a transparent horizontal list container.

```luau
Reactily.Layout.Horizontal(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.Vertical`

Creates a transparent vertical list container.

```luau
Reactily.Layout.Vertical(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.Wrap`

Creates a transparent wrapping list container.

```luau
Reactily.Layout.Wrap(options: ListOptions?, children: { any }): Reactily.Element
```

### `Layout.Grid`

Creates a grid container backed by UIGridLayout.

```luau
Reactily.Layout.Grid(options: GridOptions, children: { any }): Reactily.Element
```

### `Layout.Stack`

Creates a transparent stacking container where children share the same bounds.

```luau
Reactily.Layout.Stack(options: CommonOptions?, children: { any }): Reactily.Element
```

### `Layout.Center`

Creates a container whose children are centered by UIListLayout.

```luau
Reactily.Layout.Center(options: CommonOptions?, children: { any }): Reactily.Element
```
