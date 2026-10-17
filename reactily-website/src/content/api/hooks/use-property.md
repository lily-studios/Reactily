---
title: Reactily.useProperty
description: Subscribes to a Roblox Instance property.
---

# `Reactily.useProperty`

Subscribes to a Roblox Instance property. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useProperty<T>(instance: Instance, propertyName: string): T
```

## Usage

```luau
local visible = Reactily.useProperty(frame, "Visible")
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

This hook observes a native Roblox Instance property and exposes its value while the component renders.

### Practical guidance

Use the property’s exact Roblox name, such as `"AbsoluteSize"` or `"Visible"`. Avoid observing a property on an Instance that may be destroyed without handling its lifecycle.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes to a Roblox Instance property. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
