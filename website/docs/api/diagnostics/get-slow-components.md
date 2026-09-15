---
title: Reactily.getSlowComponents
sidebar_label: getSlowComponents
sidebar_position: 5
description: API reference for Reactily.getSlowComponents.
---

# `Reactily.getSlowComponents`

Returns the slowest recorded components ordered by average render time.

## Signature
```typescript
Reactily.getSlowComponents(limit: number?): {{component: any, profile: componentProfile}}
```
## Usage
```typescript
local slowComponents = Reactily.getSlowComponents(10)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getProfilerSnapshot`, `getRenderReason`.
