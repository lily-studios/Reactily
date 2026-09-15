---
title: Reactily.createAtom
sidebar_label: createAtom
sidebar_position: 4
description: API reference for Reactily.createAtom.
---

# `Reactily.createAtom`

Creates standalone change-only typed state.

## Signature
```typescript
Reactily.createAtom<T>(initialValue: T): atom<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `initialValue` | `T` | Yes | Initial typed value. |

## Returns

A `atom<T>`.

## Usage
```typescript
local level = Reactily.createAtom(.7)
```
