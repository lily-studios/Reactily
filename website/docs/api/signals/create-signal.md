---
title: Reactily.createSignal
sidebar_label: createSignal
sidebar_position: 2
description: API reference for Reactily.createSignal.
---

# `Reactily.createSignal`

Creates a typed Reactily signal.

## Signature
```typescript
Reactily.createSignal<T>(): signal<T>
```
## Parameters

_No parameters._

## Returns

A `signal<T>`.

## Usage
```typescript
local selected = Reactily.createSignal<number>()
selected.connect(print)
selected.fire(5)
```
