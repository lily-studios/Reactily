---
title: Reactily.createLifecycleOwner
sidebar_label: createLifecycleOwner
sidebar_position: 3
description: API reference for Reactily.createLifecycleOwner.
---

# `Reactily.createLifecycleOwner`

Creates a low-level owner record for connections, Instances, and cleanups.

## Signature
```luau
Reactily.createLifecycleOwner(): LifecycleOwner
```
## Parameters

_No parameters._

## Returns

A low-level Reactily lifecycle owner record.

## Usage
```luau
local owner = Reactily.createLifecycleOwner()
```

## Understanding this API

Low-level runtime helpers give application code explicit control over scheduling, resource lifetimes, or object reuse. They are useful for infrastructure and frequently created objects.

### Practical guidance

Prefer the higher-level Reactily APIs when possible. When you create an owned handle or pool, plan when it should be deleted or released so stale listeners and unused Instances do not accumulate.

## Additional usage notes

### When to use it

Use this creator when you need the LifecycleOwner capability described above, and keep its result under a clear owner.

### Behavior and ownership

Runtime helpers manage reusable objects, cleanup, and ownership details.

### Pitfalls to avoid

> **Note:** Make sure resources are returned to their owner or released when no longer needed.
