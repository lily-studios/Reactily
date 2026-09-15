---
title: Reactily.createUIScale
sidebar_label: createUIScale
sidebar_position: 20
description: API reference for Reactily.createUIScale.
---

# `Reactily.createUIScale`

Creates a typed virtual `UIScale` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIScale(props: uiScaleProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiScaleProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local scale = Reactily.createUIScale({
	scale = 1.1,
})
```
