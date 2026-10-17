---
title: Reactily.Shortcut
sidebar_label: Shortcut
sidebar_position: 27
description: Public Reactily Shortcut module.
---

# `Reactily.Shortcut`

`Reactily.Shortcut` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Shortcut helpers connect key combinations to application actions without hardwiring input handling inside every component.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Shortcut.create`

Creates an owned keyboard shortcut.

```luau
Reactily.Shortcut.create(options: ShortcutOptions, callback: () -> ()): InputBinding
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

