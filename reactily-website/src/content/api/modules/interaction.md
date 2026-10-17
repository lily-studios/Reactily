---
title: Reactily.Interaction
sidebar_label: Interaction
sidebar_position: 12
description: Public Reactily Interaction module.
---

# `Reactily.Interaction`

`Reactily.Interaction` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use an interaction controller to coordinate button-like hover, focus, or active visual feedback for existing GUI objects.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Interaction.bind`

Binds hover, pressed, focused, and disabled visual states to a GuiObject.

```luau
Reactily.Interaction.bind(object: GuiObject, options: InteractionOptions): InteractionController
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

