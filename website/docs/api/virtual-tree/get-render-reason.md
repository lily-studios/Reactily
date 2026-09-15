---
title: Reactily.getRenderReason
sidebar_label: getRenderReason
sidebar_position: 8
description: API reference for Reactily.getRenderReason.
---

# `Reactily.getRenderReason`

Returns the latest recorded reason a component rendered.

## Signature
```typescript
Reactily.getRenderReason(componentValue: any): string?
```
## Usage
```typescript
local reason = Reactily.getRenderReason(component)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getProfile`, `inspectRoot`.
