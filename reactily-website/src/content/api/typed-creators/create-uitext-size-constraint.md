---
title: Reactily.createUITextSizeConstraint
sidebar_label: createUITextSizeConstraint
sidebar_position: 23
description: API reference for Reactily.createUITextSizeConstraint.
---

# `Reactily.createUITextSizeConstraint`

Creates a typed virtual `UITextSizeConstraint` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUITextSizeConstraint(props: UITextSizeConstraintProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UITextSizeConstraintProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local constraint = Reactily.createUITextSizeConstraint({
	MinTextSize = 14,
	MaxTextSize = 32,
})
```
