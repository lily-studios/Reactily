---
title: Reactily.Command
sidebar_label: command
sidebar_position: 2
description: Public Reactily command module.
---

# `Reactily.Command`

`Reactily.Command` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Command helpers model named operations separately from visual controls so multiple UI actions can invoke the same behavior.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Command.create`

Creates a command registry that can share actions across buttons, menus, and shortcuts.

```luau
Reactily.Command.create(): CommandRegistry
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

