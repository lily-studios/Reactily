---
title: Reactily.createUIPageLayout
sidebar_label: createUIPageLayout
sidebar_position: 19
description: API reference for Reactily.createUIPageLayout.
---

# `Reactily.createUIPageLayout`

Creates a typed virtual `UIPageLayout` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createUIPageLayout(props: UIPageLayoutProps?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `UIPageLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local layout = Reactily.createUIPageLayout({
	Animated = true,
	Circular = false,
})
```
