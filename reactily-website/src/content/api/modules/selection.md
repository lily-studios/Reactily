---
title: Reactily.Selection
sidebar_label: Selection
sidebar_position: 26
description: Public Reactily Selection module.
---

# `Reactily.Selection`

`Reactily.Selection` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Selection state helpers track which items are selected, supporting interfaces such as tables, lists, or inspectors.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Selection.create`

Creates a typed multi-selection controller.

```luau
Reactily.Selection.create<T>(initialValues: { T }?): selection<T>
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

