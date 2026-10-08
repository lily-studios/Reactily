---
title: Reactily.createSignal
sidebar_label: createSignal
sidebar_position: 2
description: API reference for Reactily.createSignal.
---

# `Reactily.createSignal`

Creates a typed Reactily signal.

## Signature
```luau
Reactily.createSignal<T>(): Signal<T>
```
## Parameters

_No parameters._

## Returns

A `Signal<T>`.

## Usage
```luau
local Selected = Reactily.createSignal<number>()
local Connection = Selected.Connect(print)
Selected.Fire(5)
Connection.Disconnect()
Selected.Delete()
```
