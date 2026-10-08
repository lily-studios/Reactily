---
title: Reactily.Children
sidebar_label: Children
sidebar_position: 1
description: Public Reactily Children module.
---

# `Reactily.Children`

`Reactily.Children` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Children.Count`

Counts normalized Reactily children.

```luau
Reactily.Children.Count(children: { any }): number
```

### `Children.ForEach`

Invokes a callback for every normalized child.

```luau
Reactily.Children.ForEach(children: { any }, callback: (child: Reactily.Element, index: number) -> ())
```

### `Children.Map`

Maps normalized children and flattens returned child arrays.

```luau
Reactily.Children.Map( children: { any }, callback: (child: Reactily.Element, index: number) -> any ): { Reactily.Element }
```

### `Children.Only`

Returns the only normalized child and errors when the count differs from one.

```luau
Reactily.Children.Only(children: { any }): Reactily.Element
```

### `Children.ToArray`

Flattens nested children into a new ordered array.

```luau
Reactily.Children.ToArray(children: { any }): { Reactily.Element }
```
