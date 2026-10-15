---
title: Reactily.History
sidebar_label: History
sidebar_position: 9
description: Public Reactily History module.
---

# `Reactily.History`

`Reactily.History` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

History helpers provide undo/redo-oriented state operations for data that changes through user actions.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `History.create`

Creates bounded undo/redo history.

```luau
Reactily.History.create<T>(initialValue: T, capacity: number?): history<T>
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

