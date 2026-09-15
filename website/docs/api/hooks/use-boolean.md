---
title: Reactily.useBoolean
sidebar_label: useBoolean
sidebar_position: 4
description: API reference for Reactily.useBoolean.
---

# `Reactily.useBoolean`

Provides boolean state plus stable enable, disable, and toggle functions.

## Signature
```typescript
Reactily.useBoolean(initialValue: boolean?): (boolean, () -> (), () -> (), () -> ())
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `boolean?` | No | Initial typed value. |

## Returns

`(boolean, () -> (), () -> (), () -> ())`.

## Usage
```typescript
local enabled, enable, disable, toggle = Reactily.useBoolean(false)
```
