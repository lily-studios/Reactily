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
