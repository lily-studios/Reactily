---
title: Reactily.Profiler
sidebar_label: Profiler
sidebar_position: 20
description: Public Reactily Profiler module.
---

# `Reactily.Profiler`

`Reactily.Profiler` is a public namespace exported by the runtime. Its methods are listed below.

## Methods

### `Profiler.clear`

Clears all collected profiler data.

```luau
Reactily.Profiler.clear()
```

### `Profiler.isEnabled`

Returns whether component profiling is enabled.

```luau
Reactily.Profiler.isEnabled(): boolean
```

### `Profiler.get`

Returns a copy of profile data for one component.

```luau
Reactily.Profiler.get(componentValue: component): componentProfile?
```

### `Profiler.snapshot`

Returns all currently collected component profiles.

```luau
Reactily.Profiler.snapshot(): profileMap
```

### `Profiler.getSlowComponents`

Returns the slowest recorded components ordered by average render time.

```luau
Reactily.Profiler.getSlowComponents(limit: number?): { slowComponent }
```

### `Profiler.record`

Records one component render when profiling is enabled.

```luau
Reactily.Profiler.record(componentValue: component, duration: number, reason: string)
```

### `Profiler.setEnabled`

Enables or disables component profiling.

```luau
Reactily.Profiler.setEnabled(value: boolean)
```
