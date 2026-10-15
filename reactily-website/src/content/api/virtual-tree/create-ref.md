---
title: Reactily.createRef
sidebar_label: createRef
sidebar_position: 31
description: Creates a mutable Reactily ref object.
---

# `Reactily.createRef`

Creates a mutable Reactily ref object.

## Signature

```luau
Reactily.createRef<T>(): Ref<T?>
```

## Usage

```luau
local Ref = Reactily.createRef()
```

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use refs when parent or helper code needs to track a mounted host target without turning that target into component state.

### Behavior and ownership

The ref receives its target on mount and should clear when it is detached.

### Pitfalls to avoid

> **Note:** Read the ref after mounting; it may be nil before reconciliation completes.
