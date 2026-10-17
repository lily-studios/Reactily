---
title: Reactily.flattenChildren
sidebar_label: flattenChildren
sidebar_position: 7
description: API reference for Reactily.flattenChildren.
---

# `Reactily.flattenChildren`

Flattens nested Reactily child arrays and removes false/nil entries.

## Signature
```luau
Reactily.flattenChildren(children: {any}): {Element}
```
## Usage
```luau
local Children = Reactily.flattenChildren({
	first,
	{second, third},
	false,
	nil,
})
```
## Works with

Pairs naturally with `createFragment`, component children, keyed reconciliation.

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this when building reusable APIs that accept nested lists of elements.

### Behavior and ownership

It turns supported nested child values into a flat ordered element list.

### Pitfalls to avoid

> **Note:** Unlike `Children.only`, flattening does not assert that there is exactly one child.
