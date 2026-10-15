---
title: Reactily.isValidElement
sidebar_label: isValidElement
sidebar_position: 32
description: Returns whether a value is a Reactily element.
---

# `Reactily.isValidElement`

Returns whether a value is a Reactily element.

## Signature

```luau
Reactily.isValidElement(value: any): boolean
```

## Usage

```luau
if Reactily.isValidElement(value) then
	print("Reactily Element")
end
```

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use this helper when returns whether a value is a Reactily element.

### Behavior and ownership

Virtual tree operations determine how elements are represented or reconciled into Roblox Instances.

### Pitfalls to avoid

> **Note:** Do not treat Reactily element tables as native Roblox Instances.
