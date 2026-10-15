---
title: Reactily.Drag
sidebar_label: Drag
sidebar_position: 6
description: Public Reactily Drag module.
---

# `Reactily.Drag`

`Reactily.Drag` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

A drag controller tracks pointer movement and provides behavior for movable GUI controls.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Drag.bind`

Makes a GuiObject draggable using input events only while dragging.

```luau
Reactily.Drag.bind(target: GuiObject, options: DragOptions?): DragController
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

