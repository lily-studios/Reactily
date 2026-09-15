---
title: Reactily.flattenChildren
sidebar_label: flattenChildren
sidebar_position: 7
description: API reference for Reactily.flattenChildren.
---

# `Reactily.flattenChildren`

Flattens nested Reactily child arrays and removes false/nil entries.

## Signature
```typescript
Reactily.flattenChildren(children: {any}): {element}
```
## Usage
```typescript
local children = Reactily.flattenChildren({
	first,
	{second, third},
	false,
	nil,
})
```
## Works with

Pairs naturally with `createFragment`, component children, keyed reconciliation.
