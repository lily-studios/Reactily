---
title: Reactily.useProperty
description: Subscribes to a Roblox Instance property.
---

# `Reactily.useProperty`

Subscribes to a Roblox Instance property. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useProperty<T>(instance: Instance, propertyName: string): T
```

## Usage

```luau
local visible = Reactily.useProperty(frame, "Visible")
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
