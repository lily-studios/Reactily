---
title: Reactily.IsValidElement
description: Compatibility alias that checks whether a value is a Reactily element.
---

# `Reactily.IsValidElement`

Compatibility alias that checks whether a value is a Reactily element. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.isValidElement
```

## Usage

```luau
if Reactily.isValidElement(value) then
	-- value is a Reactily Element
end
```

For parameter details and examples, follow the modern camelCase API linked below.

## v2.2.0 migration note

The public API generator in the supplied Luau source exposes `Reactily.isValidElement`, not the older PascalCase `Reactily.IsValidElement` spelling. For new code, use [`Reactily.isValidElement`](../virtual-tree/is-valid-element.md) instead.

## Additional usage notes

### When to use it

Use this helper when compatibility alias that checks whether a value is a Reactily element. This export is present in the Reactily v2.1.0 package (API v1).

### Behavior and ownership

This API integrates with rendering, lifecycle, or host behavior through Reactily’s public contract.

### Pitfalls to avoid

> **Note:** Check whether the operation must be called during rendering or during an event callback.
