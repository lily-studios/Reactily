---
title: Reactily.CloneElement
description: Compatibility alias for cloning a Reactily element with additional props or children.
---

# `Reactily.CloneElement`

Compatibility alias for cloning a Reactily element with additional props or children. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.cloneElement
```

## Usage

```luau
local nextElement = Reactily.cloneElement(Element, { Key = "updated" })
```

For parameter details and examples, follow the modern camelCase API linked below.

## v2.2.0 migration note

The public API generator in the supplied Luau source exposes `Reactily.cloneElement`, not the older PascalCase `Reactily.CloneElement` spelling. For new code, use [`Reactily.cloneElement`](../virtual-tree/clone-element.md) instead.

## Additional usage notes

### When to use it

Use this helper when compatibility alias for cloning a Reactily element with additional props or children. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
