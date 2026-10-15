---
title: Reactily.Modal
sidebar_label: Modal
sidebar_position: 16
description: Public Reactily Modal module.
---

# `Reactily.Modal`

`Reactily.Modal` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

A modal helper builds a virtual dialog-like container and its associated children.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Modal.create`

Creates a full-screen modal overlay element around children.

```luau
Reactily.Modal.create(options: ModalOptions?, children: { any }): Reactily.Element
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

