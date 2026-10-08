---
title: Reactily.useSyncExternalStore
sidebar_label: useSyncExternalStore
sidebar_position: 50
description: Subscribes to an external store and returns its current snapshot.
---

# `Reactily.useSyncExternalStore`

Subscribes to an external store and returns its current snapshot.

## Signature

```luau
Reactily.useSyncExternalStore<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
```

## Usage

```luau
local value = Reactily.useSyncExternalStore(subscribe, getSnapshot)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
