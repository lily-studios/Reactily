---
title: Reactily.CreateRef
description: Compatibility alias for creating a Reactily ref.
---

# `Reactily.CreateRef`

Compatibility alias for creating a Reactily ref. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.createRef
```

## Usage

```luau
local Ref = Reactily.createRef()
```

For parameter details and examples, follow the modern camelCase API linked below.

## v2.2.0 migration note

The public API generator in the supplied Luau source exposes `Reactily.createRef`, not the older PascalCase `Reactily.CreateRef` spelling. For new code, use [`Reactily.createRef`](../virtual-tree/create-ref.md) instead.

## Additional usage notes

### When to use it

Use this helper when compatibility alias for creating a Reactily ref. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
