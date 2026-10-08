---
title: Reactily.Layout
sidebar_label: Layout
sidebar_position: 14
description: Public Reactily Layout module.
---

# `Reactily.Layout`

`Reactily.Layout` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Layout.horizontal`

Creates a transparent horizontal list container.

```luau
Reactily.Layout.horizontal(options: ListOptions?, children: { any }): elementModule.Element
```

### `Layout.vertical`

Creates a transparent vertical list container.

```luau
Reactily.Layout.vertical(options: ListOptions?, children: { any }): elementModule.Element
```

### `Layout.wrap`

Creates a transparent wrapping list container.

```luau
Reactily.Layout.wrap(options: ListOptions?, children: { any }): elementModule.Element
```

### `Layout.grid`

Creates a grid container backed by UIGridLayout.

```luau
Reactily.Layout.grid(options: GridOptions, children: { any }): elementModule.Element
```

### `Layout.stack`

Creates a transparent stacking container where children share the same bounds.

```luau
Reactily.Layout.stack(options: CommonOptions?, children: { any }): elementModule.Element
```

### `Layout.center`

Creates a container whose children are centered by UIListLayout.

```luau
Reactily.Layout.center(options: CommonOptions?, children: { any }): elementModule.Element
```
