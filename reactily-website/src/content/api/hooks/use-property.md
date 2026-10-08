---
title: Reactily.useProperty
sidebar_label: useProperty
sidebar_position: 48
description: Subscribes to a Roblox Instance property.
---

# `Reactily.useProperty`

Subscribes to a Roblox Instance property.

## Signature

```luau
Reactily.useProperty<T>(instance: Instance, propertyName: string): T
```

## Usage

```luau
local visible = Reactily.useProperty(frame, "Visible")
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
