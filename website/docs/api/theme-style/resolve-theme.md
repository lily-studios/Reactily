---
title: Reactily.resolveTheme
sidebar_label: resolveTheme
sidebar_position: 5
description: API reference for Reactily.resolveTheme.
---

# `Reactily.resolveTheme`

Immediately derives a value from the theme's current tokens.

## Signature
```typescript
Reactily.resolveTheme<T, R>(themeValue: theme<T>, selectorFunction: (tokens: T) -> R): R
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `themeValue` | `theme<T>` | Yes | Reactily theme whose current token value is read. |
| `selectorFunction` | `(tokens: T) -> R` | Yes | Function that derives a selected/computed value from the source. |

## Returns

`R`.

## Usage
```typescript
local accent = Reactily.resolveTheme(theme, function(tokens)
	return tokens.accent
end)
```
