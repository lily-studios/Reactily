---
title: Reactily.takeSignal
sidebar_label: takeSignal
sidebar_position: 8
description: API reference for Reactily.takeSignal.
---

# `Reactily.takeSignal`

Creates a derived signal that forwards at most `maximum` source emissions.

## Signature
```luau
Reactily.takeSignal<T>(source: Signal<T>, maximum: number): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `maximum` | `number` | Yes | Maximum allowed value or maximum number of signal emissions to forward. |

## Returns

A `Signal<T>`.

## Usage
```luau
local firstFive = Reactily.takeSignal(source, 5)
```

## Understanding this API

Signals carry discrete notifications from a producer to one or more listeners. Unlike component state, a signal represents an event or stream of values rather than the current rendered state.

### Practical guidance

Keep the returned connection or unsubscribe handle when registering a listener. Disconnect listeners when their owner is deleted, especially when capturing Instances, GUI objects, or component-specific state.

## Additional usage notes

### When to use it

Use this helper when creates a derived signal that forwards at most maximum source emissions.

### Behavior and ownership

Signals represent event-like notifications rather than a persistent value that can be reread later.

### Pitfalls to avoid

> **Note:** Disconnect listeners you no longer need. Avoid using event streams as a replacement for shared state.
