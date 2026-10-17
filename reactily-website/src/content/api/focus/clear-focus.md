---
title: Reactily.clearFocus
sidebar_label: clearFocus
sidebar_position: 2
description: API reference for Reactily.clearFocus.
---

# `Reactily.clearFocus`

Clears Roblox `GuiService.SelectedObject`.

## Signature
```luau
Reactily.clearFocus()
```
## Parameters

_No parameters._

## Returns

No value.

## Usage
```luau
Reactily.clearFocus()
```

## Understanding this API

Focus helpers coordinate UI selection and keyboard/gamepad navigation through Roblox GUI services.

### Practical guidance

A focus target must be a valid selectable GuiObject that still exists in the DataModel. Roblox may reject selections made after an element has been destroyed or removed.

## Additional usage notes

### When to use it

Use this helper when clears Roblox GuiService.SelectedObject.

### Behavior and ownership

Focus helpers interact with Roblox selection and input state through Reactily-managed abstractions.

### Pitfalls to avoid

> **Note:** A target may be absent or destroyed during transitions; guard operations that require a live GuiObject.
