---
title: Reactily.useBinding
sidebar_label: useBinding
sidebar_position: 3
description: API reference for Reactily.useBinding.
---

# `Reactily.useBinding`

Creates and owns a Reactily binding for the component lifetime.

## Signature
```luau
Reactily.useBinding<T>(initialValue: T): Binding<T>
```
## Usage
```luau
local Binding = Reactily.useBinding(0)
```
## Works with

Pairs naturally with `bindProperty`, `bindAttribute`, binding transforms.
