---
title: Reactily.new
sidebar_label: new
sidebar_position: 2
description: API reference for Reactily.new.
---

# `Reactily.new`

Alias of `Reactily.createRoot(parent)`.

## Signature
```typescript
Reactily.new(parent: Instance): root
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `parent` | `Instance` | Yes | Roblox Instance that receives the root's rendered host tree. |

## Returns

A Reactily render root.

## Usage
```typescript
local root = Reactily.new(playerGui)
```
