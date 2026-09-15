---
title: Reactily.formatBinding
sidebar_label: formatBinding
sidebar_position: 8
description: API reference for Reactily.formatBinding.
---

# `Reactily.formatBinding`

Creates a derived string binding using a formatter.

## Signature
```typescript
Reactily.formatBinding<T>(source: binding<T>, formatter: (value: T) -> string): binding<string>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `binding<T>` | Yes | Source Reactily atom, binding, or signal. |
| `formatter` | `(value: T) -> string` | Yes | Function that converts the source value into a display string. |

## Returns

A `binding<string>`.

## Usage
```typescript
local text = Reactily.formatBinding(progress, function(value)
	return `{math.round(value * 100)}%`
end)
```
