---
title: Reactily.Profiler
sidebar_label: Profiler
sidebar_position: 20
description: Public Reactily Profiler module.
---

# `Reactily.Profiler`

`Reactily.Profiler` is a public namespace exported by the runtime. Its methods are listed below.

## Understanding this namespace

The `Profiler` namespace contains measurement controls as well as a callable profiler component. Enable measurement before recording; use snapshots and slow-component lists to inspect observed rendering behavior.

Use the lowercase/camelCase methods shown in the signatures below. Roblox engine properties such as `Size`, `Position`, `BackgroundColor3`, and `ViewportSize` retain their official PascalCase names.

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
Reactily.Profiler.get(componentValue: Component): ComponentProfile?
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
Reactily.Profiler.record(componentValue: Component, duration: number, reason: string)
```

### `Profiler.setEnabled`

Enables or disables component profiling.

```luau
Reactily.Profiler.setEnabled(value: boolean)
```

## Reading profiler results

Enable recording first, reproduce the interaction you want to measure, and then inspect the results. `get` gives the profile for one component function; `snapshot` gives copies of the recorded profiles; `getSlowComponents` sorts the profiles by average render time. The `renderCount`, `averageTime`, and `totalTime` values should be interpreted together.

Calling `clear` empties the collected data without replacing the profiler module. This is useful before measuring a new interaction, so samples from an unrelated earlier test do not skew your investigation.

## Notes and common mistakes

- **Input:** Pass the same component function identity that is rendered, not the element returned from that function.
- **Common mistake:** Expecting an unprofiled component to have stats. Enable profiling before collecting samples.

