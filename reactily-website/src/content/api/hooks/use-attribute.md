---
title: Reactily.useAttribute
sidebar_label: useAttribute
sidebar_position: 2
description: API reference for Reactily.useAttribute.
---

# `Reactily.useAttribute`

Uses component state synchronized with a Roblox Attribute.

## Signature
```luau
Reactily.useAttribute<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): (T, (value: T) -> ())
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `instance` | `Instance` | Yes | Roblox Instance used by the requested Reactily helper. |
| `attributeName` | `string` | Yes | Roblox Attribute name owned or observed by this Reactily state helper. |
| `defaultValue` | `T` | Yes | Fallback value used when the Roblox Attribute currently has no value. |

## Returns

`(T, (value: T) -> ())`.

## Usage
```luau
local enabled, setEnabled = Reactily.useAttribute(
	item,
	"enabled",
	true
)
```

## Understanding this API

This hook reads an Attribute from a Roblox Instance and keeps the component aligned with attribute changes.

### Practical guidance

An Attribute is not a native property; use the attribute key passed to `GetAttribute` or `SetAttribute` rather than a Roblox property name.

## Additional usage notes

### When to use it

Use this hook when the component needs uses component state synchronized with a Roblox Attribute.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
