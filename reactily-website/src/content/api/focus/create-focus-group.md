---
title: Reactily.createFocusGroup
sidebar_label: createFocusGroup
sidebar_position: 3
description: API reference for Reactily.createFocusGroup.
---

# `Reactily.createFocusGroup`

Creates a focus collection for keyboard/controller GUI selection.

## Signature
```luau
Reactily.createFocusGroup(): FocusGroup
```
## Parameters

_No parameters._

## Returns

A GUI focus group.

## Usage
```luau
local group = Reactily.createFocusGroup()
group.add(playButton)
group.focusFirst()
```

## Understanding this API

Focus helpers coordinate UI selection and keyboard/gamepad navigation through Roblox GUI services.

### Practical guidance

A focus target must be a valid selectable GuiObject that still exists in the DataModel. Roblox may reject selections made after an element has been destroyed or removed.

## Additional usage notes

### When to use it

Use this creator when you need the FocusGroup capability described above, and keep its result under a clear owner.

### Behavior and ownership

Focus helpers interact with Roblox selection and input state through Reactily-managed abstractions.

### Pitfalls to avoid

> **Note:** A target may be absent or destroyed during transitions; guard operations that require a live GuiObject.
