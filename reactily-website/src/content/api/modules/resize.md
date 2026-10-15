---
title: Reactily.Resize
sidebar_label: Resize
sidebar_position: 22
description: Public Reactily Resize module.
---

# `Reactily.Resize`

`Reactily.Resize` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

A resize controller tracks interaction for changing GUI element dimensions.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Resize.bind`

Makes a GuiObject resizable from a dedicated handle GuiObject.

```luau
Reactily.Resize.bind(target: GuiObject, handle: GuiObject, options: ResizeOptions?): ResizeController
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

