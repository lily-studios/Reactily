---
title: Reactily.Layer
sidebar_label: Layer
sidebar_position: 13
description: Public Reactily Layer module.
---

# `Reactily.Layer`

`Reactily.Layer` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Layer helpers make stacking and overlay management explicit instead of scattering display-order values.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Layer.create`

Creates an owned ScreenGui layer manager for portals, overlays, modals, and tooltips.

```luau
Reactily.Layer.create(parent: Instance, definitions: { [string]: LayerDefinition }?): LayerManager
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

