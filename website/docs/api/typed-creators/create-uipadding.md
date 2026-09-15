---
title: Reactily.createUIPadding
sidebar_label: createUIPadding
sidebar_position: 18
description: API reference for Reactily.createUIPadding.
---

# `Reactily.createUIPadding`

Creates a typed virtual `UIPadding` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIPadding(props: uiPaddingProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiPaddingProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local padding = Reactily.createUIPadding({
	paddingLeft = UDim.new(0, 12),
	paddingRight = UDim.new(0, 12),
})
```
