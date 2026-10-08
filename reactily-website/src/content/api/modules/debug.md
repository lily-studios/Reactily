---
title: Reactily.Debug
sidebar_label: Debug
sidebar_position: 4
description: Public Reactily Debug module.
---

# `Reactily.Debug`

`Reactily.Debug` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Debug.FormatTree`

Formats a root inspection snapshot as a readable tree.

```luau
Reactily.Debug.FormatTree(snapshot: any): string
```

### `Debug.Inspect`

Returns profiler information and a formatted runtime tree for a root.

```luau
Reactily.Debug.Inspect(rootValue: any): any
```
