---
title: Reactily.roundBinding
sidebar_label: roundBinding
sidebar_position: 10
description: API reference for Reactily.roundBinding.
---

# `Reactily.roundBinding`

Creates a derived numeric binding rounded to the requested decimal precision.

## Signature
```luau
Reactily.roundBinding(source: Binding<number>, precision: number): Binding<number>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<number>` | Yes | Source Reactily atom, binding, or signal. |
| `precision` | `number` | Yes | Number of decimal places retained by numeric rounding. |

## Returns

A `Binding<number>`.

## Usage
```luau
local rounded = Reactily.roundBinding(valueBinding, 2)
```

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when creates a derived numeric binding rounded to the requested decimal precision.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
