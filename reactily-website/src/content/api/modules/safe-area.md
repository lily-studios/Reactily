---
title: Reactily.SafeArea
sidebar_label: SafeArea
sidebar_position: 24
description: Public Reactily SafeArea module.
---

# `Reactily.SafeArea`

`Reactily.SafeArea` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Safe-area helpers account for screen insets when placing UI near device edges.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `SafeArea.getInsets`

Returns current Roblox GUI inset values in pixels.

```luau
Reactily.SafeArea.getInsets(): SafeAreaInsets
```

### `SafeArea.padding`

Creates a UIPadding element from current Roblox GUI insets.

```luau
Reactily.SafeArea.padding(): Reactily.Element
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

