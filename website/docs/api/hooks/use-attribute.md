---
title: Reactily.useAttribute
sidebar_label: useAttribute
sidebar_position: 2
description: API reference for Reactily.useAttribute.
---

# `Reactily.useAttribute`

Uses component state synchronized with a Roblox Attribute.

## Signature
```typescript
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
```typescript
local enabled, setEnabled = Reactily.useAttribute(
	item,
	"enabled",
	true
)
```
