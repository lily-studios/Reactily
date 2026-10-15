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

## Understanding this API

This reads the collected timing information for a particular component function.

### Practical guidance

If there has been no recorded render for that function, no profile may be available. Profiling must be enabled before recording work.

## Additional usage notes

### When to use it

Use this to inspect measurements for one component function.

### Behavior and ownership

It returns recorded profile information when profiling has been enabled and that component has rendered.

### Pitfalls to avoid

> **Note:** A missing entry does not necessarily mean the component never rendered; profiling may have been disabled.
