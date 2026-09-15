---
title: Reactily.createAttributeAtom
sidebar_label: createAttributeAtom
sidebar_position: 5
description: API reference for Reactily.createAttributeAtom.
---

# `Reactily.createAttributeAtom`

Creates an atom synchronized bidirectionally with one Roblox Attribute.

## Signature
```typescript
Reactily.createAttributeAtom<T>(
	instance: Instance,
	attributeName: string,
	defaultValue: T
): atom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `instance` | `Instance` | Yes | Roblox Instance used by the requested Reactily helper. |
| `attributeName` | `string` | Yes | Roblox Attribute name owned or observed by this Reactily state helper. |
| `defaultValue` | `T` | Yes | Fallback value used when the Roblox Attribute currently has no value. |

## Returns

A `atom<T>`.

## Usage
```typescript
local enabled = Reactily.createAttributeAtom(item, "enabled", true)
```
