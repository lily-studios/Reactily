---
title: Reactily.getProfile
sidebar_label: getProfile
sidebar_position: 3
description: API reference for Reactily.getProfile.
---

# `Reactily.getProfile`

Returns a copy of profile data for one component.

## Signature
```luau
Reactily.getProfile(componentValue: Component<any>): ComponentProfile?
```
## Usage
```luau
local profile = Reactily.getProfile(Component)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getRenderReason`, `inspectRoot`.
