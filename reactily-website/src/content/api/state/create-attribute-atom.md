---
title: Reactily.createAttributeAtom
sidebar_label: createAttributeAtom
sidebar_position: 5
description: API reference for Reactily.createAttributeAtom.
---

# `Reactily.createAttributeAtom`

Creates an atom synchronized bidirectionally with one Roblox Attribute.

## Signature
```luau
Reactily.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): Atom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `instance` | `Instance` | Yes | Roblox Instance used by the requested Reactily helper. |
| `attributeName` | `string` | Yes | Roblox Attribute name owned or observed by this Reactily state helper. |
| `defaultValue` | `T` | Yes | Fallback value used when the Roblox Attribute currently has no value. |

## Returns

A `Atom<T>`.

## Usage
```luau
local Enabled = Reactily.createAttributeAtom(item, "enabled", true)
```

## Understanding this API

This function works with state that may be observed or manipulated independently of one component. Use it to keep application data and rendering responsibilities separate.

### Practical guidance

Keep references to shared state in a stable location instead of recreating them on every render. Use computed values and selectors for derived data, and use batched updates when several related changes should be grouped.

## Additional usage notes

### When to use it

Use this creator when you need the AttributeAtom capability described above, and keep its result under a clear owner.

### Behavior and ownership

This API works with reactive or shared values outside the scope of a single UI update.

### Pitfalls to avoid

> **Note:** Do not mutate shared tables without going through the owning state API when subscriptions depend on updates.
