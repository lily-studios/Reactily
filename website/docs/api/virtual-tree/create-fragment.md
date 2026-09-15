---
title: Reactily.createFragment
sidebar_label: createFragment
sidebar_position: 4
description: API reference for Reactily.createFragment.
---

# `Reactily.createFragment`

Groups children without creating a Roblox host Instance.

## Signature
```typescript
Reactily.createFragment(children: {element}, key: string?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `children` | `{element}` | Yes | Optional child Reactily elements rendered beneath this element/component. |
| `key` | `string?` | No | Optional stable identity key used by reconciliation. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local fragment = Reactily.createFragment({
	firstElement,
	secondElement,
}, "group")
```
