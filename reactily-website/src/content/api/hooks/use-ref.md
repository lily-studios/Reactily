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
Reactily.useRef<T>(initialValue: T): Ref<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

`Ref<T>`.

## Usage
```luau
local dragging = Reactily.useRef(false)
dragging.current = true
```

## Understanding this API

A ref holds a mutable value across renders without using a state update to schedule a rerender. Host refs can also provide access to the mounted Roblox Instance.

### Practical guidance

Do not assume a host ref already points to an Instance during the first render; the value becomes available after mounting and may clear on unmount.

## Additional usage notes

### When to use it

Use a ref to retain a mutable value across renders or access a mounted host instance.

### Behavior and ownership

Updating a ref does not itself request a render.

### Pitfalls to avoid

> **Note:** Use state instead when changing the value must update visible UI.
