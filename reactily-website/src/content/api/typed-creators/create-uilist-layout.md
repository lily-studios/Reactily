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
Reactily.createUIListLayout(props: uiListLayoutProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiListLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```luau
local layout = Reactily.createUIListLayout({
	padding = UDim.new(0, 8),
	fillDirection = Enum.FillDirection.Vertical,
})
```
