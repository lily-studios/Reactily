---
title: Reactily.createUIPadding
sidebar_label: createUIPadding
sidebar_position: 18
description: API reference for Reactily.createUIPadding.
---

# `Reactily.createUIPadding`

Creates a typed virtual `UIPadding` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIPadding(props: UIPaddingProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIPaddingProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Padding = Reactily.createUIPadding({
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
})
```
