---
title: Reactily.inspectRoot
sidebar_label: inspectRoot
sidebar_position: 9
description: API reference for Reactily.inspectRoot.
---

# `Reactily.inspectRoot`

Returns a diagnostic snapshot of a mounted Reactily root tree.

## Signature
```luau
Reactily.inspectRoot(rootValue: Root): any
```
## Usage
```luau
local snapshot = Reactily.inspectRoot(Root)
```
## Works with

Pairs naturally with profiling, render reasons, reconciliation diagnostics.

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this helper when returns a diagnostic snapshot of a mounted Reactily root tree.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
