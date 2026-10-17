---
title: Reactily.mergeSignals
sidebar_label: mergeSignals
sidebar_position: 6
description: API reference for Reactily.mergeSignals.
---

# `Reactily.mergeSignals`

Creates a derived signal that forwards emissions from all supplied sources.

## Signature
```luau
Reactily.mergeSignals<T>(sources: {Signal<T>}): Signal<T>
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `sources` | `{Signal<T>}` | Yes | Source signals to merge into one derived signal. |

## Returns

A `Signal<T>`.

## Usage
```luau
local merged = Reactily.mergeSignals({
	firstSignal,
	secondSignal,
})
```

## Understanding this API

Signals carry discrete notifications from a producer to one or more listeners. Unlike component state, a signal represents an event or stream of values rather than the current rendered state.

### Practical guidance

Keep the returned connection or unsubscribe handle when registering a listener. Disconnect listeners when their owner is deleted, especially when capturing Instances, GUI objects, or component-specific state.

## Additional usage notes

### When to use it

Use this helper when creates a derived signal that forwards emissions from all supplied sources.

### Behavior and ownership

Signals represent event-like notifications rather than a persistent value that can be reread later.

### Pitfalls to avoid

> **Note:** Disconnect listeners you no longer need. Avoid using event streams as a replacement for shared state.
