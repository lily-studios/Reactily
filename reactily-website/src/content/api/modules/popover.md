---
title: Reactily.Popover
sidebar_label: Popover
sidebar_position: 18
description: Public Reactily Popover module.
---

# `Reactily.Popover`

`Reactily.Popover` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Popover positioning is useful for menus, tooltips, and context panels anchored to other GUI objects.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Popover.place`

Positions a popover GuiObject relative to an anchor.

```luau
Reactily.Popover.place(anchor: GuiObject, object: GuiObject, options: PopoverOptions?): UDim2
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

