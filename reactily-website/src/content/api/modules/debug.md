---
title: Reactily.Debug
sidebar_label: Debug
sidebar_position: 4
description: Public Reactily Debug module.
---

# `Reactily.Debug`

`Reactily.Debug` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Debug.formatTree`

Formats a root inspection snapshot as a readable tree.

```luau
Reactily.Debug.formatTree(snapshot: any): string
```

### `Debug.inspect`

Returns profiler information and a formatted runtime tree for a root.

```luau
Reactily.Debug.inspect(rootValue: any): any
```
