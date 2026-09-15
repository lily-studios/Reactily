---
title: Reactily.getProfilerSnapshot
sidebar_label: getProfilerSnapshot
sidebar_position: 4
description: API reference for Reactily.getProfilerSnapshot.
---

# `Reactily.getProfilerSnapshot`

Returns all currently collected component profiles.

## Signature
```typescript
Reactily.getProfilerSnapshot(): {[any]: componentProfile}
```
## Usage
```typescript
local profiles = Reactily.getProfilerSnapshot()
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getSlowComponents`, `resetProfiler`.
