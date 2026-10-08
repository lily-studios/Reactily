---
title: Reactily.formatBinding
sidebar_label: formatBinding
sidebar_position: 8
description: API reference for Reactily.formatBinding.
---

# `Reactily.formatBinding`

Creates a derived string binding using a formatter.

## Signature
```luau
Reactily.formatBinding<T>(source: Binding<T>, formatter: (value: T) -> string): Binding<string>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Binding<T>` | Yes | Source Reactily atom, binding, or signal. |
| `formatter` | `(value: T) -> string` | Yes | Function that converts the source value into a display string. |

## Returns

A `Binding<string>`.

## Usage
```luau
local Text = Reactily.formatBinding(progress, function(value)
	return `{math.round(value * 100)}%`
end)
```
