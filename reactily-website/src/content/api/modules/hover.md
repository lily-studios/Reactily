---
title: Reactily.Hover
sidebar_label: Hover
sidebar_position: 10
description: Public Reactily Hover module.
---

# `Reactily.Hover`

`Reactily.Hover` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use `Hover.bind` to apply temporary property changes to a GuiObject while it is hovered. The controller tracks the normal property values so hover styling can be undone when the interaction ends.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Hover.bind`

Binds a hover style and automatically restores the original Roblox property values.

```luau
Reactily.Hover.bind( object: GuiObject, style: Reactily.InteractionStyle ): Reactily.InteractionController
```

## When to use hover binding

Use `Hover.bind` for a GUI object that already exists and should temporarily change appearance under the pointer. Unlike a component-level conditional prop, a hover controller is attached to a concrete `GuiObject`; it should have the same lifetime as that object. Do not confuse `Reactily.Hover.bind` with Roblox's native `MouseEnter`/`MouseLeave` events.

## Notes and common mistakes

- **Input:** Bind hover behavior to a supported live GuiObject and keep its controller under the same lifetime as the target.
- **Common mistake:** Leaving hover controllers connected after their target has been destroyed.

