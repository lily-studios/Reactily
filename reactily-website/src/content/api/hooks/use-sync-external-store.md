---
title: Reactily.useSyncExternalStore
description: Subscribes to an external store and returns its current snapshot.
---

# `Reactily.useSyncExternalStore`

Subscribes to an external store and returns its current snapshot. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useSyncExternalStore<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
```

## Usage

```luau
local value = Reactily.useSyncExternalStore(subscribe, getSnapshot)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

Use this hook when the source of truth already exists outside Reactily, for example in a standalone store that can publish notifications.

### Practical guidance

The subscription and snapshot mechanisms must describe the same external value. A subscription should be cleaned up when a component stops observing it.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes to an external store and returns its current snapshot. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
