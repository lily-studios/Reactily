---
title: Reactily.useDevice
description: Subscribes the component to Reactily device and viewport state.
---

# `Reactily.useDevice`

Subscribes the component to Reactily device and viewport state. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useDevice(): DeviceState
```

## Usage

```luau
local device = Reactily.useDevice()
print(device.ViewportSize)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
