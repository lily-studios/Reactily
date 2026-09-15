---
title: Reactily.createUIAspectRatioConstraint
sidebar_label: createUIAspectRatioConstraint
sidebar_position: 13
description: API reference for Reactily.createUIAspectRatioConstraint.
---

# `Reactily.createUIAspectRatioConstraint`

Creates a typed virtual `UIAspectRatioConstraint` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIAspectRatioConstraint(props: uiAspectRatioConstraintProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiAspectRatioConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local constraint = Reactily.createUIAspectRatioConstraint({
	aspectRatio = 16 / 9,
})
```
