---
title: Reactily.VirtualWindow
sidebar_label: VirtualWindow
sidebar_position: 33
description: Public Reactily VirtualWindow module.
---

# `Reactily.VirtualWindow`

`Reactily.VirtualWindow` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use a window controller when the visible region and scroll position are managed together for a virtualized UI.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `VirtualWindow.new`

Creates a cached controller for variable-size virtualized lists.

```luau
Reactily.VirtualWindow.new(sizes: { number }, viewportSize: number, overscan: number?): VariableVirtualList
```

### `VirtualWindow.resolve`

Resolves a visible range for variable-size items.

```luau
Reactily.VirtualWindow.resolve(sizes: { number }, scrollOffset: number, viewportSize: number, overscan: number?): VariableVirtualRange
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

