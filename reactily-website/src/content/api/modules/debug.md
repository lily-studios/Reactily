---
title: Reactily.Debug
sidebar_label: Debug
sidebar_position: 4
description: Public Reactily Debug module.
---

# `Reactily.Debug`

`Reactily.Debug` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Tree debugging helpers make reconciled Reactily structures easier to inspect during development. They are for diagnostics rather than normal rendering.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

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

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

