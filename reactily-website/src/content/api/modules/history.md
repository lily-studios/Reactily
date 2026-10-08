---
title: Reactily.History
sidebar_label: History
sidebar_position: 9
description: Public Reactily History module.
---

# `Reactily.History`

`Reactily.History` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `History.Create`

Creates bounded undo/redo history.

```luau
Reactily.History.Create<T>(initialValue: T, capacity: number?): history<T>
```
