---
title: Reactily.Attributes
sidebar_label: Attributes
sidebar_position: 1
description: Host metadata key used to assign Roblox Attributes declaratively.
---

# `Reactily.Attributes`

Host metadata key used to assign Roblox Attributes declaratively.

## Usage

```luau
local props = {}
props[Reactily.Attributes] = { Selected = true }
```

## Understanding this API

Special elements and host metadata influence how Reactily reconciles children or applies behavior that is not represented by a single ordinary Roblox class.

### Practical guidance

Use the documented input shape rather than guessing Roblox properties. Reactily-specific metadata is different from native Instance properties and may be handled specially by the renderer.

## Additional usage notes

### When to use it

Use this helper when host metadata key used to assign Roblox Attributes declaratively.

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
