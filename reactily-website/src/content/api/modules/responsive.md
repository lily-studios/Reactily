---
title: Reactily.Responsive
sidebar_label: Responsive
sidebar_position: 23
description: Public Reactily Responsive module.
---

# `Reactily.Responsive`

`Reactily.Responsive` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use this namespace to select values based on viewport breakpoints without scattering device-size checks through individual components.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Responsive.resolve`

Resolves a responsive value from viewport width.

```luau
Reactily.Responsive.resolve<T>(viewportSize: Vector2, values: ResponsiveValues<T>, options: ResponsiveBreakpoints?): T
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

