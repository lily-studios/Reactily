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

## Understanding this API

A binding stores a typed value that other bindings or Roblox property targets can observe.

### Practical guidance

Use `mapBinding` to derive another representation (for example, a number converted into text) and `bindProperty` when an existing Instance should receive changes.

## Additional usage notes

### When to use it

Use bindings when a changing value should drive a supported Roblox property or participate in a derived reactive expression.

### Behavior and ownership

Bindings connect value changes to the consumers that observe them.

### Pitfalls to avoid

> **Note:** Release bindings and attached connections with their owner to avoid keeping unused UI alive.
