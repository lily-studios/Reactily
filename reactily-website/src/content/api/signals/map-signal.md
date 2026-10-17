---
title: Reactily.mapSignal
sidebar_label: mapSignal
sidebar_position: 5
description: API reference for Reactily.mapSignal.
---

# `Reactily.mapSignal`

Creates a derived signal by transforming every emitted source value.

## Signature
```luau
Reactily.mapSignal<A, B>(source: Signal<A>, mapper: (value: A) -> B): Signal<B>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<A>` | Yes | Source Reactily atom, binding, or signal. |
| `mapper` | `(value: A) -> B` | Yes | Function that transforms one or more source values into the derived value. |

## Returns

A `Signal<B>`.

## Usage
```luau
local labels = Reactily.mapSignal(source, function(value)
	return `Item {value}`
end)
```

## Understanding this API

Signals carry discrete notifications from a producer to one or more listeners. Unlike component state, a signal represents an event or stream of values rather than the current rendered state.

### Practical guidance

Keep the returned connection or unsubscribe handle when registering a listener. Disconnect listeners when their owner is deleted, especially when capturing Instances, GUI objects, or component-specific state.

## Additional usage notes

### When to use it

Use this helper when creates a derived signal by transforming every emitted source value.

### Behavior and ownership

Signals represent event-like notifications rather than a persistent value that can be reread later.

### Pitfalls to avoid

> **Note:** Disconnect listeners you no longer need. Avoid using event streams as a replacement for shared state.
