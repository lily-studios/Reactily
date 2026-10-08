---
title: Reactily.useDevice
sidebar_label: useDevice
sidebar_position: 43
description: Subscribes the component to Reactily device and viewport state.
---

# `Reactily.useDevice`

Subscribes the component to Reactily device and viewport state.

## Signature

```luau
Reactily.useDevice(): deviceModule.deviceState
```

## Usage

```luau
local device = Reactily.useDevice()
print(device.viewportSize)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
