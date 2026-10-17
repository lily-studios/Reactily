---
title: Reactily.createDiagnostics
sidebar_label: createDiagnostics
sidebar_position: 2
description: API reference for Reactily.createDiagnostics.
---

# `Reactily.createDiagnostics`

Creates explicit runtime counters with no background polling.

## Signature
```luau
Reactily.createDiagnostics(): Diagnostics
```
## Parameters

_No parameters._

## Returns

A diagnostics counter owner.

## Usage
```luau
local Diagnostics = Reactily.createDiagnostics()
Diagnostics.increment("renders")
```

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this creator when you need the Diagnostics capability described above, and keep its result under a clear owner.

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
