---
title: Reactily.Profiler
sidebar_label: Profiler
sidebar_position: 20
description: Public Reactily Profiler module.
---

# `Reactily.Profiler`

`Reactily.Profiler` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Profiler.Clear`

Clears all collected profiler data.

```luau
Reactily.Profiler.Clear()
```

### `Profiler.IsEnabled`

Returns whether component profiling is enabled.

```luau
Reactily.Profiler.IsEnabled(): boolean
```

### `Profiler.Get`

Returns a copy of profile data for one component.

```luau
Reactily.Profiler.Get(componentValue: Component): ComponentProfile?
```

### `Profiler.Snapshot`

Returns all currently collected component profiles.

```luau
Reactily.Profiler.Snapshot(): profileMap
```

### `Profiler.GetSlowComponents`

Returns the slowest recorded components ordered by average render time.

```luau
Reactily.Profiler.GetSlowComponents(limit: number?): { slowComponent }
```

### `Profiler.Record`

Records one component render when profiling is enabled.

```luau
Reactily.Profiler.Record(componentValue: Component, duration: number, reason: string)
```

### `Profiler.SetEnabled`

Enables or disables component profiling.

```luau
Reactily.Profiler.SetEnabled(value: boolean)
```
