---
title: Reactily.useShortcut
sidebar_label: useShortcut
sidebar_position: 49
description: Binds a keyboard shortcut for the lifetime of the component.
---

# `Reactily.useShortcut`

Binds a keyboard shortcut for the lifetime of the component.

## Signature

```luau
Reactily.useShortcut(options: shortcutModule.shortcutOptions, callback: () -> ())
```

## Usage

```luau
Reactily.useShortcut({ key = Enum.KeyCode.K }, function()
	print("Shortcut pressed")
end)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
