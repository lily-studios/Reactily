---
title: Reactily.createPortal
sidebar_label: createPortal
sidebar_position: 5
description: API reference for Reactily.createPortal.
---

# `Reactily.createPortal`

Creates a virtual portal that reconciles children into another Roblox target.

## Signature
```luau
Reactily.createPortal(target: Instance, children: {Element}, key: string?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `target` | `Instance` | Yes | Roblox Instance that receives portal children. |
| `children` | `{Element}` | Yes | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local portal = Reactily.createPortal(overlayGui, {
	modalElement,
}, "modal")
```

## Understanding this API

Reactily describes the requested user interface using virtual elements. Creating an element does not immediately insert a Roblox Instance into the DataModel; mounting and updates occur through a render root.

### Practical guidance

Use these functions while building a component tree, then render the result with `Reactily.createRoot(parent).render(element)`. Treat element descriptions as values rather than attempting to call Roblox Instance methods on them.

## Additional usage notes

### When to use it

Use a portal when a component must render into a different Roblox host while staying in the same Reactily tree.

### Behavior and ownership

The portal redirects the host parent used for its children.

### Pitfalls to avoid

> **Note:** The destination must exist for the portal to mount correctly. Avoid manually destroying the destination while a portal depends on it.
