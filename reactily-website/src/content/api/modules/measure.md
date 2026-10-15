---
title: Reactily.Measure
sidebar_label: measure
sidebar_position: 15
description: Public Reactily measure module.
---

# `Reactily.Measure`

`Reactily.Measure` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Use measurements when interface layout depends on observed bounds instead of fixed constants.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Measure.create`

Observes AbsolutePosition and AbsoluteSize for a GuiObject.

```luau
Reactily.Measure.create(object: GuiObject): Measure
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

