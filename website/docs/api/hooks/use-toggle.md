---
title: Reactily.useToggle
sidebar_label: useToggle
sidebar_position: 30
description: API reference for Reactily.useToggle.
---

# `Reactily.useToggle`

Provides boolean state, a toggle function, and an explicit setter.

## Signature
```typescript
Reactily.useToggle(initialValue: boolean?): (boolean, () -> (), (value: boolean) -> ())
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `boolean?` | No | Initial typed value. |

## Returns

`(boolean, () -> (), (value: boolean) -> ())`.

## Usage
```typescript
local open, toggle, setOpen = Reactily.useToggle(false)
toggle()
setOpen(true)
```
