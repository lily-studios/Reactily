---
title: Reactily.createUIScale
sidebar_label: createUIScale
sidebar_position: 20
description: API reference for Reactily.createUIScale.
---

# `Reactily.createUIScale`

Creates a typed virtual `UIScale` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIScale(props: UIScaleProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIScaleProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Scale = Reactily.createUIScale({
	Scale = 1.1,
})
```
