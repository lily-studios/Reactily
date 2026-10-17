---
title: Reactily.getSlowComponents
sidebar_label: getSlowComponents
sidebar_position: 5
description: API reference for Reactily.getSlowComponents.
---

# `Reactily.getSlowComponents`

Returns the slowest recorded components ordered by average render time.

## Signature
```luau
Reactily.getSlowComponents(limit: number?): {{Component: any, profile: ComponentProfile}}
```
## Usage
```luau
local slowComponents = Reactily.getSlowComponents(10)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getProfilerSnapshot`, `getRenderReason`.

## Understanding this API

This sorts the collected component profiles so the highest average render times can be investigated first.

### Practical guidance

A high average with very few samples can be misleading. Compare render counts and total time before deciding what to optimize.

## Additional usage notes

### When to use it

Use this to find render-heavy components during profiling sessions.

### Behavior and ownership

It sorts collected component profiles by average measured render time.

### Pitfalls to avoid

> **Note:** Compare profiles under similar workloads; average render time is not the same as a continuous FPS measurement.
