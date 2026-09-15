---
title: Reactily.createComponent
sidebar_label: createComponent
sidebar_position: 2
description: API reference for Reactily.createComponent.
---

# `Reactily.createComponent`

Creates a virtual function-component element.

## Signature
```typescript
Reactily.createComponent<P>(
	componentValue: component<P>,
	props: P,
	children: {element}?,
	key: string?
): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `componentValue` | `component<P>` | Yes | Typed Reactily function component to render. |
| `props` | `P` | Yes | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createComponent(counter, {})
```
