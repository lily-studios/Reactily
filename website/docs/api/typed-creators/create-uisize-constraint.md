---
title: Reactily.createUISizeConstraint
sidebar_label: createUISizeConstraint
sidebar_position: 21
description: API reference for Reactily.createUISizeConstraint.
---

# `Reactily.createUISizeConstraint`

Creates a typed virtual `UISizeConstraint` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUISizeConstraint(props: uiSizeConstraintProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiSizeConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local constraint = Reactily.createUISizeConstraint({
	minSize = Vector2.new(200, 100),
	maxSize = Vector2.new(800, 600),
})
```
