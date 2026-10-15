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
Connection.disconnect()
Selected.delete()
```

## Understanding this API

Signals are useful for events such as a custom component action, a controller notification, or an application-level message.

### Practical guidance

Producers fire values and consumers connect listeners. Remember to disconnect listeners when their owner is no longer active.

## Additional usage notes

### When to use it

Use signals for discrete events, not for values that need to be read later.

### Behavior and ownership

Listeners receive values when the signal fires, while the signal does not automatically become persistent state.

### Pitfalls to avoid

> **Note:** Keep and disconnect the returned connection once the listener is no longer needed.
