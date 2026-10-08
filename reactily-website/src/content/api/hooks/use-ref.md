---
title: Reactily.useRef
sidebar_label: useRef
sidebar_position: 26
description: API reference for Reactily.useRef.
---

# `Reactily.useRef`

Creates persistent mutable component storage that does not trigger rerenders.

## Signature
```luau
Reactily.useRef<T>(initialValue: T): ref<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

`ref<T>`.

## Usage
```luau
local dragging = Reactily.useRef(false)
dragging.current = true
```
