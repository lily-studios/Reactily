---
title: Reactily.createTextButton
sidebar_label: createTextButton
sidebar_position: 11
description: API reference for Reactily.createTextButton.
---

# `Reactily.createTextButton`

Creates a typed virtual `TextButton` element with class-specific prop autocomplete.

## Signature
```luau
Reactily.createTextButton(props: TextButtonProps?, children: {Element}?): Element
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `props` | `TextButtonProps?` | No | Typed property table for this Roblox host class. |
| `children` | `{Element}?` | No | Optional child Reactily elements rendered beneath this element/component. |

## Returns

A virtual `Reactily.Element`.

## Usage
```luau
local Element = Reactily.createTextButton({
	Size = UDim2.fromOffset(220, 56),
	Text = "Continue",
	OnActivated = function()
		print("Continue")
	end,
})
```

## Understanding this API

A `TextButton` element is intended for clickable actions. The `OnActivated` handler runs when Roblox activates the button through a supported input method.

### Practical guidance

Use `OnActivated` with its exact casing. Keep expensive or asynchronous work outside rendering; the callback should initiate the action, not be called while constructing the element.

## Additional usage notes

### When to use it

Use a text button for clickable actions, menu items, and interactive controls.

### Behavior and ownership

Pass Roblox GUI properties as the element props; attach events using the supported Reactily host event keys.

### Pitfalls to avoid

> **Note:** Use `OnActivated` for a typical button action, not a manually connected `.Activated` signal inside the rendering function.
