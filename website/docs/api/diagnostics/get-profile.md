---
title: Reactily.getProfile
sidebar_label: getProfile
sidebar_position: 3
description: API reference for Reactily.getProfile.
---

# `Reactily.getProfile`

Returns a copy of profile data for one component.

## Signature
```typescript
Reactily.getProfile(componentValue: component<any>): componentProfile?
```
## Usage
```typescript
local profile = Reactily.getProfile(component)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getRenderReason`, `inspectRoot`.
