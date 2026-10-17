---
title: Reactily.skipSignal
sidebar_label: skipSignal
sidebar_position: 7
description: API reference for Reactily.skipSignal.
---

# `Reactily.skipSignal`

Creates a derived signal that ignores the first `amount` source emissions.

## Signature
```luau
Reactily.skipSignal<T>(source: Signal<T>, amount: number): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `amount` | `number` | Yes | Number of source emissions to skip, decrement by, or otherwise apply as the requested amount. |

## Returns

A `Signal<T>`.

## Usage
```luau
local afterWarmup = Reactily.skipSignal(source, 2)
```

## Understanding this API

Signals carry discrete notifications from a producer to one or more listeners. Unlike component state, a signal represents an event or stream of values rather than the current rendered state.

### Practical guidance

Keep the returned connection or unsubscribe handle when registering a listener. Disconnect listeners when their owner is deleted, especially when capturing Instances, GUI objects, or component-specific state.

## Additional usage notes

### When to use it

Use this helper when creates a derived signal that ignores the first amount source emissions.

### Behavior and ownership

Signals represent event-like notifications rather than a persistent value that can be reread later.

### Pitfalls to avoid

> **Note:** Disconnect listeners you no longer need. Avoid using event streams as a replacement for shared state.
