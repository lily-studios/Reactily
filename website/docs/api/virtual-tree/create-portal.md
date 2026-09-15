---
title: Reactily.createPortal
sidebar_label: createPortal
sidebar_position: 5
description: API reference for Reactily.createPortal.
---

# `Reactily.createPortal`

Creates a virtual portal that reconciles children into another Roblox target.

## Signature
```typescript
Reactily.createPortal(target: Instance, children: {element}, key: string?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `target` | `Instance` | Yes | Roblox Instance that receives portal children. |
| `children` | `{element}` | Yes | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local portal = Reactily.createPortal(overlayGui, {
	modalElement,
}, "modal")
```
