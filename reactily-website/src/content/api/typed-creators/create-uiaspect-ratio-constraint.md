---
title: Reactily.createUIAspectRatioConstraint
sidebar_label: createUIAspectRatioConstraint
sidebar_position: 13
description: API reference for Reactily.createUIAspectRatioConstraint.
---

# `Reactily.createUIAspectRatioConstraint`

Creates a typed virtual `UIAspectRatioConstraint` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIAspectRatioConstraint(props: UIAspectRatioConstraintProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIAspectRatioConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local constraint = Reactily.createUIAspectRatioConstraint({
	AspectRatio = 16 / 9,
})
```
