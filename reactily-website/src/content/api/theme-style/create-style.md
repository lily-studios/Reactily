---
title: Reactily.createStyle
sidebar_label: createStyle
sidebar_position: 3
description: API reference for Reactily.createStyle.
---

# `Reactily.createStyle`

Merges ordered style tables into one new style.

## Signature
```luau
Reactily.createStyle(styles: {Style}): Style
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `styles` | `{Style}` | Yes | Ordered style tables. Later entries overwrite earlier properties. |

## Returns

A new merged Reactily style table.

## Usage
```luau
local styleValue = Reactily.createStyle({
	baseStyle,
	selectedStyle,
})
```
