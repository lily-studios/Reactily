---
title: Reactily.Tooltip
sidebar_label: tooltip
sidebar_position: 29
description: Public Reactily tooltip module.
---

# `Reactily.Tooltip`

`Reactily.Tooltip` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

This namespace collects closely related Reactily helpers so callers can find and reuse them under one name.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Tooltip.attach`

Attaches an owned tooltip to a GuiObject.

```luau
Reactily.Tooltip.attach(parent: Instance, target: GuiObject, text: string, options: TooltipOptions?): Tooltip
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

