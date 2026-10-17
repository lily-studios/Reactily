---
title: Reactily.combineBindings
sidebar_label: combineBindings
sidebar_position: 5
description: API reference for Reactily.combineBindings.
---

# `Reactily.combineBindings`

Creates a derived binding from two source bindings.

## Signature
```luau
Reactily.combineBindings<A, B, R>(
	first: Binding<A>,
	second: Binding<B>,
	mapper: (firstValue: A, secondValue: B) -> R
): Binding<R>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `first` | `Binding<A>` | Yes | First source binding. |
| `second` | `Binding<B>` | Yes | Second source binding. |
| `mapper` | `(firstValue: A, secondValue: B) -> R` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `Binding<R>`.

## Usage
```luau
local point = Reactily.combineBindings(x, y, function(xValue, yValue)
	return Vector2.new(xValue, yValue)
end)
```

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when creates a derived binding from two source bindings.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
