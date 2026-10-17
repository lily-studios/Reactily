---
title: Reactily.resetProfiler
sidebar_label: resetProfiler
sidebar_position: 7
description: API reference for Reactily.resetProfiler.
---

# `Reactily.resetProfiler`

Clears all collected profiler data.

## Signature
```luau
Reactily.resetProfiler(): ()
```
## Usage
```luau
Reactily.resetProfiler()
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getProfilerSnapshot`, `getSlowComponents`.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this helper when clears all collected profiler data.

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
