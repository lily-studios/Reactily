---
title: Reactily.createRoot
sidebar_label: createRoot
sidebar_position: 6
description: API reference for Reactily.createRoot.
---

# `Reactily.createRoot`

Creates a Reactily render root under a Roblox parent.

## Signature
```typescript
Reactily.createRoot(parent: Instance): root
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `parent` | `Instance` | Yes | Roblox Instance that receives the root's rendered host tree. |

## Returns

A Reactily render root.

## Usage
```typescript
local root = Reactily.createRoot(playerGui)
root.render(appElement)
```
