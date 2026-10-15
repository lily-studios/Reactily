---
title: Reactily.setProfilingEnabled
sidebar_label: setProfilingEnabled
sidebar_position: 8
description: API reference for Reactily.setProfilingEnabled.
---

# `Reactily.setProfilingEnabled`

Enables or disables component profiling.

## Signature
```luau
Reactily.setProfilingEnabled(value: boolean): ()
```
## Usage
```luau
Reactily.setProfilingEnabled(true)
```
## Works with

Pairs naturally with `getProfile`, `getProfilerSnapshot`, `getSlowComponents`, `getRenderReason`.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Enable profiling only when you want diagnostic measurements.

### Behavior and ownership

Measurements accumulate while enabled until reset using the profiler API.

### Pitfalls to avoid

> **Note:** Profiling itself can add some overhead; disable it during normal production gameplay if it is not needed.
