---
title: Reactily.createElement
sidebar_label: createElement
sidebar_position: 3
description: API reference for Reactily.createElement.
---

# `Reactily.createElement`

Creates a generic Roblox host element. Prefer a typed creator when one exists.

## Signature
```luau
Reactily.createElement(
	className: string,
	props: {[string]: any}?,
	children: {Element}?
): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `className` | `string` | Yes | Roblox Instance class name to create or pool. |
| `props` | `{[string]: any}?` | No | Optional table of Roblox host properties. Prefer the typed creator for a supported Instance class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createElement("Frame", {
	Size = UDim2.fromOffset(300, 180),
})
```

## Understanding this API

This is the generic host-element factory for classes or shapes not covered by a specialized typed creator.

### Practical guidance

Prefer `createFrame`, `createTextLabel`, and other typed helpers for clearer autocomplete and prop checking; use this lower-level helper when generic construction is intentional.

## Additional usage notes

### When to use it

Use `createElement` to instantiate a function component or generic Reactily element. For native Roblox GUI objects, dedicated creators such as `createFrame` provide clearer types.

### Behavior and ownership

The returned value describes UI; it is not a Roblox `Instance` until a root reconciles it.

### Pitfalls to avoid

> **Note:** Do not call `:Destroy()` on an element descriptor. Unmount it through the owning root instead.
