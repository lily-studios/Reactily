---
title: Reactily.createUICorner
sidebar_label: createUICorner
sidebar_position: 14
description: API reference for Reactily.createUICorner.
---

# `Reactily.createUICorner`

Creates a typed virtual `UICorner` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUICorner(props: UICornerProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UICornerProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local corner = Reactily.createUICorner({
	CornerRadius = UDim.new(0, 10),
})
```
