---
title: Reactily.createBinding
sidebar_label: createBinding
sidebar_position: 7
description: API reference for Reactily.createBinding.
---

# `Reactily.createBinding`

Creates a standalone reactive binding.

## Signature
```typescript
Reactily.createBinding<T>(initialValue: T): binding<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

A `binding<T>`.

## Usage
```typescript
local progress = Reactily.createBinding(.5)
```
