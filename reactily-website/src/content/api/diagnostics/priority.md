---
title: Reactily.Priority
description: priority constants used to classify scheduled Reactily work.
---

# `Reactily.Priority`

priority constants used to classify scheduled Reactily work. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.Priority
```

## Usage

```luau
local Priority = Reactily.Priority
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.

## Understanding this API

Diagnostics APIs expose information about work performed by Reactily, or enable additional checks that help explain rendering behavior.

### Practical guidance

Use diagnostics during development or targeted performance investigations. Profiling data reflects measured renders, not a complete trace of all Roblox engine work, and some instrumentation should be disabled when no longer needed.

## Additional usage notes

### When to use it

Use this helper when priority constants used to classify scheduled Reactily work. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

Diagnostic helpers are for investigation and instrumentation rather than essential gameplay behavior.

### Pitfalls to avoid

> **Note:** Do not assume collected debug values reflect all rendering activity when profiling is disabled.
