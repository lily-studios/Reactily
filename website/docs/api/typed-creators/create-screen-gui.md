---
title: Reactily.createScreenGui
sidebar_label: createScreenGui
sidebar_position: 7
description: API reference for Reactily.createScreenGui.
---

# `Reactily.createScreenGui`

Creates a typed virtual `ScreenGui` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createScreenGui(props: screenGuiProps?, children: {element}?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `screenGuiProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local element = Reactily.createScreenGui({
	name = "Interface",
	resetOnSpawn = false,
}, {
	Reactily.createFrame({
		size = UDim2.fromScale(1, 1),
	}),
})
```
