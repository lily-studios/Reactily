---
title: Reactily.createUISizeConstraint
sidebar_label: createUISizeConstraint
sidebar_position: 21
description: API reference for Reactily.createUISizeConstraint.
---

# `Reactily.createUISizeConstraint`

Creates a typed virtual `UISizeConstraint` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUISizeConstraint(props: UISizeConstraintProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UISizeConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local constraint = Reactily.createUISizeConstraint({
	MinSize = Vector2.new(200, 100),
	MaxSize = Vector2.new(800, 600),
})
```
