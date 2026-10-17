---
title: Reactily.key
sidebar_label: key
sidebar_position: 10
description: API reference for Reactily.key.
---

# `Reactily.key`

Returns a clone of an element with a stable key.

## Signature
```luau
Reactily.key(key: string, elementValue: Element): Element
```
## Usage
```luau
local Element = Reactily.createTextLabel({ Text = item.name })
local keyed = Reactily.key(tostring(item.id), Element)
```
## Works with

Pairs naturally with lists, virtualization, keyed reconciliation.

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this helper when returns a clone of an element with a stable key.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
