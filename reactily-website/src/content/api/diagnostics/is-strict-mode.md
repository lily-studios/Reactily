---
title: Reactily.isStrictMode
sidebar_label: isStrictMode
sidebar_position: 6
description: API reference for Reactily.isStrictMode.
---

# `Reactily.isStrictMode`

Returns whether Reactily strict development checks are enabled.

## Signature
```luau
Reactily.isStrictMode(): boolean
```
## Usage
```luau
print(Reactily.isStrictMode())
```
## Works with

Pairs naturally with `setStrictMode`, diagnostics, development validation.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this helper when returns whether Reactily strict development checks are enabled.

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
