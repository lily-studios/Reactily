---
title: Reactily.Children
sidebar_label: Children
sidebar_position: 1
description: Public Reactily Children module.
---

# `Reactily.Children`

`Reactily.Children` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Children.count`

Counts normalized Reactily children.

```luau
Reactily.Children.count(children: { any }): number
```

### `Children.forEach`

Invokes a callback for every normalized child.

```luau
Reactily.Children.forEach(children: { any }, callback: (child: elementModule.Element, index: number) -> ())
```

### `Children.map`

Maps normalized children and flattens returned child arrays.

```luau
Reactily.Children.map( children: { any }, callback: (child: elementModule.Element, index: number) -> any ): { elementModule.Element }
```

### `Children.only`

Returns the only normalized child and errors when the count differs from one.

```luau
Reactily.Children.only(children: { any }): elementModule.Element
```

### `Children.toArray`

Flattens nested children into a new ordered array.

```luau
Reactily.Children.toArray(children: { any }): { elementModule.Element }
```
