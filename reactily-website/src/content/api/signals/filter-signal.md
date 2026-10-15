---
title: Reactily.filterSignal
sidebar_label: filterSignal
sidebar_position: 4
description: API reference for Reactily.filterSignal.
---

# `Reactily.filterSignal`

Creates a derived signal that forwards only values accepted by `predicate`.

## Signature
```luau
Reactily.filterSignal<T>(source: Signal<T>, predicate: (value: T) -> boolean): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `source` | `Signal<T>` | Yes | Source Reactily atom, binding, or signal. |
| `predicate` | `(value: T) -> boolean` | Yes | Function returning `true` when a signal value should be forwarded. |

## Returns

A `Signal<T>`.

## Usage
```luau
local even = Reactily.filterSignal(source, function(value)
	return value % 2 == 0
end)
```

## Understanding this API

Signals carry discrete notifications from a producer to one or more listeners. Unlike component state, a signal represents an event or stream of values rather than the current rendered state.

### Practical guidance

Keep the returned connection or unsubscribe handle when registering a listener. Disconnect listeners when their owner is deleted, especially when capturing Instances, GUI objects, or component-specific state.

## Additional usage notes

### When to use it

Use this helper when creates a derived signal that forwards only values accepted by predicate.

### Behavior and ownership

Signals represent event-like notifications rather than a persistent value that can be reread later.

### Pitfalls to avoid

> **Note:** Disconnect listeners you no longer need. Avoid using event streams as a replacement for shared state.
