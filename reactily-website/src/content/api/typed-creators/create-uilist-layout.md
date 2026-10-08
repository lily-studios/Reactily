---
title: Reactily.createUIListLayout
sidebar_label: createUIListLayout
sidebar_position: 17
description: API reference for Reactily.createUIListLayout.
---

# `Reactily.createUIListLayout`

Creates a typed virtual `UIListLayout` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIListLayout(props: UIListLayoutProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIListLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local layout = Reactily.createUIListLayout({
	Padding = UDim.new(0, 8),
	FillDirection = Enum.FillDirection.Vertical,
})
```
