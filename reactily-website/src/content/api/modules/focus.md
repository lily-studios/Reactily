---
title: Reactily.Focus
sidebar_label: Focus
sidebar_position: 7
description: Public Reactily Focus module.
---

# `Reactily.Focus`

`Reactily.Focus` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use these helpers when a GUI needs controlled keyboard or gamepad focus instead of relying entirely on Roblox automatic selection.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Focus.clearSelection`

Clears the current Roblox GUI selection.

```luau
Reactily.Focus.clearSelection()
```

### `Focus.new`

Creates a focus group with forward/backward navigation.

```luau
Reactily.Focus.new(): FocusGroup
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

