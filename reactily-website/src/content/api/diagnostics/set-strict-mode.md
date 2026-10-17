---
title: Reactily.setStrictMode
sidebar_label: setStrictMode
sidebar_position: 9
description: API reference for Reactily.setStrictMode.
---

# `Reactily.setStrictMode`

Enables or disables additional development-time Reactily warnings.

## Signature
```luau
Reactily.setStrictMode(enabled: boolean): ()
```
## Usage
```luau
Reactily.setStrictMode(true)
```
## Works with

Pairs naturally with `isStrictMode`, diagnostics, development checks.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this setter when you need to update the StrictMode state through the supported API.

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
