---
title: Reactily.resolveTheme
sidebar_label: resolveTheme
sidebar_position: 5
description: API reference for Reactily.resolveTheme.
---

# `Reactily.resolveTheme`

Immediately derives a value from the theme's current tokens.

## Signature
```luau
Reactily.resolveTheme<T, R>(themeValue: Theme<T>, selectorFunction: (tokens: T) -> R): R
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `themeValue` | `Theme<T>` | Yes | Reactily theme whose current token value is read. |
| `selectorFunction` | `(tokens: T) -> R` | Yes | Function that derives a selected/computed value from the source. |

## Returns

`R`.

## Usage
```luau
local accent = Reactily.resolveTheme(Theme, function(tokens)
	return tokens.accent
end)
```
