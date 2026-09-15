---
title: Reactily.createUIPageLayout
sidebar_label: createUIPageLayout
sidebar_position: 19
description: API reference for Reactily.createUIPageLayout.
---

# `Reactily.createUIPageLayout`

Creates a typed virtual `UIPageLayout` element with class-specific prop autocomplete.

## Signature
```typescript
Reactily.createUIPageLayout(props: uiPageLayoutProps?): element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `uiPageLayoutProps?` | No | Typed property table for this Roblox host class. |

## Returns

A virtual `Reactily.element`.

## Usage
```typescript
local layout = Reactily.createUIPageLayout({
	animated = true,
	circular = false,
})
```
