---
title: Reactily.Presence
sidebar_label: presence
sidebar_position: 19
description: Public Reactily presence module.
---

# `Reactily.Presence`

`Reactily.Presence` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

Presence helps coordinate when animated content should enter, remain mounted, or leave the tree.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

## Methods

### `Presence.create`

Creates an enter/exit visibility controller for a GuiObject.

```luau
Reactily.Presence.create(object: GuiObject, options: PresenceOptions?): Presence
```

## Notes and common mistakes

- **Use:** Refer to the available method signatures above for inputs and output types; methods are ordinary Lua functions exported by this namespace.
- **Careful:** Framework method names and option keys must match their documented casing. Do not apply Roblox Instance naming rules to custom Reactily methods.

