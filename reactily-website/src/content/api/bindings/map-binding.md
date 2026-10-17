---
title: Reactily.mapBinding
sidebar_label: mapBinding
sidebar_position: 9
description: API reference for Reactily.mapBinding.
---

# `Reactily.mapBinding`

Creates a derived binding by transforming the source value.

## Signature
```luau
Reactily.mapBinding<A, B>(source: Binding<A>, mapper: (value: A) -> B): Binding<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<A>` | Yes | Source Reactily atom, binding, or signal. |
| `mapper` | `(value: A) -> B` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `Binding<B>`.

## Usage
```luau
local percent = Reactily.mapBinding(progress, function(value)
	return value * 100
end)
```

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when creates a derived binding by transforming the source value.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
