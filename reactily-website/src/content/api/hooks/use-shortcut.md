---
title: Reactily.useShortcut
description: Binds a keyboard shortcut for the lifetime of the component.
---

# `Reactily.useShortcut`

Binds a keyboard shortcut for the lifetime of the component. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useShortcut(options: ShortcutOptions, callback: () -> ())
```

## Usage

```luau
Reactily.useShortcut({ Key = Enum.KeyCode.K }, function()
	print("Shortcut pressed")
end)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
