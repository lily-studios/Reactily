---
title: Reactily.cloneElement
sidebar_label: cloneElement
sidebar_position: 30
description: Clones an existing Reactily element while merging replacement props.
---

# `Reactily.cloneElement`

Clones an existing Reactily element while merging replacement props.

## Signature

```luau
Reactily.cloneElement(elementValue: Element, props: genericProps?, children: { any }?): Element
```

## Usage

```luau
local nextElement = Reactily.cloneElement(Element, { Text = "Updated" })
```

## Understanding this API

Cloning changes an element description, not an existing mounted Roblox Instance. A clone can override props while retaining the rest of the element information.

### Practical guidance

Use stable keys where lists are reordered. A new element description may share child descriptions with the original; do not treat cloning as a deep copy of Instances.

## Additional usage notes

### When to use it

Use this helper when clones an existing Reactily element while merging replacement props.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
