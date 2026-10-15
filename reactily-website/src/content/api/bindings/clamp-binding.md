---
title: Reactily.clampBinding
sidebar_label: clampBinding
sidebar_position: 4
description: API reference for Reactily.clampBinding.
---

# `Reactily.clampBinding`

Creates a derived numeric binding clamped between `minimum` and `maximum`.

## Signature
```luau
Reactily.clampBinding(
	source: Binding<number>,
	minimum: number,
	maximum: number
): Binding<number>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<number>` | Yes | Source Reactily atom, binding, or signal. |
| `minimum` | `number` | Yes | Minimum allowed numeric value. |
| `maximum` | `number` | Yes | Maximum allowed value or maximum number of signal emissions to forward. |

## Returns

A `Binding<number>`.

## Usage
```luau
local safeProgress = Reactily.clampBinding(progress, 0, 1)
```

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when creates a derived numeric binding clamped between minimum and maximum.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
