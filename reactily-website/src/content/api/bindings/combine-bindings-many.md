---
title: Reactily.combineBindingsMany
sidebar_label: combineBindingsMany
sidebar_position: 6
description: API reference for Reactily.combineBindingsMany.
---

# `Reactily.combineBindingsMany`

Combines any number of bindings using an ordered value array.

## Signature
```luau
Reactily.combineBindingsMany<R>(sources: {Binding<any>}, mapper: (values: {any}) -> R): Binding<R>
```
## Usage
```luau
local combined = Reactily.combineBindingsMany(
	{firstBinding, secondBinding},
	function(values)
		return {
			first = values[1],
			second = values[2],
		}
	end
)
```
## Works with

Pairs naturally with `createBinding`, `mapBinding`, `bindProperty`, `bindAttribute`.

## Understanding this API

Bindings connect a changing value to dependent values or Roblox properties. They are useful when values update repeatedly and you want to avoid rebuilding unrelated parts of a component tree.

### Practical guidance

When a binding is attached to a Roblox Instance or subscribed to another source, keep and invoke any returned cleanup function when its owner is destroyed. Use a mapped binding to transform values and a direct property binding when the target is a native Roblox property.

## Additional usage notes

### When to use it

Use this helper when combines any number of bindings using an ordered value array.

### Behavior and ownership

A binding represents changing data that can be observed or transformed.

### Pitfalls to avoid

> **Note:** Avoid keeping subscriptions alive after the target Instance or owning UI is removed.
