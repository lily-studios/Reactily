---
title: Reactily.getProfilerSnapshot
sidebar_label: getProfilerSnapshot
sidebar_position: 4
description: API reference for Reactily.getProfilerSnapshot.
---

# `Reactily.getProfilerSnapshot`

Returns all currently collected component profiles.

## Signature
```luau
Reactily.getProfilerSnapshot(): {[any]: ComponentProfile}
```
## Usage
```luau
local profiles = Reactily.getProfilerSnapshot()
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getSlowComponents`, `resetProfiler`.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this accessor to read the ProfilerSnapshot information without replacing the owning value.

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
