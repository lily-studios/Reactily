---
title: Reactily.useSyncExternalStore
description: Subscribes to an external store and returns its current snapshot.
---

# `Reactily.useSyncExternalStore`

Subscribes to an external store and returns its current snapshot. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useSyncExternalStore<T>(subscribe: (callback: () -> ()) -> () -> (), getSnapshot: () -> T): T
```

## Usage

```luau
local value = Reactily.useSyncExternalStore(subscribe, getSnapshot)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
