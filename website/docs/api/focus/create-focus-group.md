---
title: Reactily.createFocusGroup
sidebar_label: createFocusGroup
sidebar_position: 3
description: API reference for Reactily.createFocusGroup.
---

# `Reactily.createFocusGroup`

Creates a focus collection for keyboard/controller GUI selection.

## Signature
```typescript
Reactily.createFocusGroup(): focusGroup
```
## Parameters

_No parameters._

## Returns

A GUI focus group.

## Usage
```typescript
local group = Reactily.createFocusGroup()
group.add(playButton)
group.focusFirst()
```
