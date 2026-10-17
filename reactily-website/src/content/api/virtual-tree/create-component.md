---
title: Reactily.createComponent
sidebar_label: createComponent
sidebar_position: 2
description: API reference for Reactily.createComponent.
---

# `Reactily.createComponent`

Creates a virtual function-component element.

## Signature
```luau
Reactily.createComponent<P>(
	componentValue: Component<P>,
	props: P,
	children: {Element}?,
	key: string?
): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `componentValue` | `Component<P>` | Yes | Typed Reactily function component to render. |
| `props` | `P` | Yes | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createComponent(counter, {})
```

## Understanding this API

This turns a Luau function into a renderable virtual component. Reactily calls the function with props when building or updating that part of the tree.

### Practical guidance

A component can call hooks, compose typed elements, and return an element. Avoid changing Instances during render; use effects for setup and cleanup.

## Additional usage notes

### When to use it

Choose this when a function must own hooks, compute child elements, or be reused with different typed props.

### Behavior and ownership

Reactily runs the component function as part of reconciliation; hooks are associated with its stable position and key.

### Pitfalls to avoid

> **Note:** Do not call a hook-using component as a plain Lua function from outside Reactily’s render flow.
