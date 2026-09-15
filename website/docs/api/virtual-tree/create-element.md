---
title: Reactily.createElement
sidebar_label: createElement
sidebar_position: 3
description: API reference for Reactily.createElement.
---

# `Reactily.createElement`

Creates a generic Roblox host element. Prefer a typed creator when one exists.

## Signature
```typescript
Reactily.createElement(
	className: string,
	props: elementModule.genericProps?,
	children: {element}?
): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `className` | `string` | Yes | Roblox Instance class name to create or pool. |
| `props` | `elementModule.genericProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createElement("Frame", {
	size = UDim2.fromOffset(300, 180),
})
```
