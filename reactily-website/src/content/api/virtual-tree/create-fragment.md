---
title: Reactily.createFragment
sidebar_label: createFragment
sidebar_position: 4
description: API reference for Reactily.createFragment.
---

# `Reactily.createFragment`

Groups children without creating a Roblox host Instance.

## Signature
```luau
Reactily.createFragment(children: {Element}, key: string?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `children` | `{Element}` | Yes | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local fragment = Reactily.createFragment({
	firstElement,
	secondElement,
}, "group")
```

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this creator when you need the Fragment capability described above, and keep its result under a clear owner.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
