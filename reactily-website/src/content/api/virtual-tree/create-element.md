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
