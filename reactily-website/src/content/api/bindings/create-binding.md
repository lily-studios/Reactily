---
title: Reactily.createBinding
sidebar_label: createBinding
sidebar_position: 7
description: API reference for Reactily.createBinding.
---

# `Reactily.createBinding`

Creates a standalone reactive binding.

## Signature
```luau
Reactily.createBinding<T>(initialValue: T): Binding<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

A `Binding<T>`.

## Usage
```luau
local progress = Reactily.createBinding(.5)
```
