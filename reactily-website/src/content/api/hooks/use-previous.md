---
title: Reactily.usePrevious
sidebar_label: usePrevious
sidebar_position: 24
description: API reference for Reactily.usePrevious.
---

# `Reactily.usePrevious`

Returns the value from the previous completed render, or `nil` initially.

## Signature
```luau
Reactily.usePrevious<T>(value: T): T?
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `value` | `T` | Yes | Typed value passed to the hook/helper. |

## Returns

`T?`.

## Usage
```luau
local previous = Reactily.usePrevious(current)
```
