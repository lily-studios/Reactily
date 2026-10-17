---
title: Reactily.useDevice
description: Subscribes the component to Reactily device and viewport state.
---

# `Reactily.useDevice`

Subscribes the component to Reactily device and viewport state. This export is included in Reactily v2.2.0 (API v1).

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

## Understanding this API

Use this hook when a component needs information about the active input device or viewport environment.

### Practical guidance

Prefer adapting layout through responsive data when the only concern is screen dimensions; device identification should not substitute for available screen space.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes the component to Reactily device and viewport state. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
