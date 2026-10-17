---
title: Reactily.formatBinding
sidebar_label: formatBinding
sidebar_position: 8
description: API reference for Reactily.formatBinding.
---

# `Reactily.formatBinding`

Creates a derived string binding using a formatter.

## Signature
```luau
Reactily.formatBinding<T>(source: Binding<T>, formatter: (value: T) -> string): Binding<string>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<T>` | Yes | Source Reactily atom, binding, or signal. |
| `formatter` | `(value: T) -> string` | Yes | Function that converts the source value into a display string. |

## Returns

A `Binding<string>`.

## Usage
```luau
local Text = Reactily.formatBinding(progress, function(value)
	return `{math.round(value * 100)}%`
end)
```

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when creates a derived string binding using a formatter.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
