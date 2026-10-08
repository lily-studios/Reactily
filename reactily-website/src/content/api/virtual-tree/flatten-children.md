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
