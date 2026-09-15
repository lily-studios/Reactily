---
title: Reactily.createUITextSizeConstraint
sidebar_label: createUITextSizeConstraint
sidebar_position: 23
description: API reference for Reactily.createUITextSizeConstraint.
---

# `Reactily.createUITextSizeConstraint`

Creates a typed virtual `UITextSizeConstraint` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUITextSizeConstraint(props: uiTextSizeConstraintProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiTextSizeConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local constraint = Reactily.createUITextSizeConstraint({
	minTextSize = 14,
	maxTextSize = 32,
})
```
