---
title: Reactily.getRenderReason
sidebar_label: getRenderReason
sidebar_position: 8
description: API reference for Reactily.getRenderReason.
---

# `Reactily.getRenderReason`

Returns the latest recorded reason a component rendered.

## Signature
```luau
Reactily.getRenderReason(componentValue: any): string?
```
## Usage
```luau
local reason = Reactily.getRenderReason(Component)
```
## Works with

Pairs naturally with `setProfilingEnabled`, `getProfile`, `inspectRoot`.

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this accessor to read the RenderReason information without replacing the owning value.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
