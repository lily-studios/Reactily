---
title: "Type: DeviceState"
sidebar_label: DeviceState
description: Luau type Reactily.DeviceState, exported from interface.device.
api_types: DeviceState
---

# `Reactily.DeviceState`

`DeviceState` is a public Luau type exported from the `interface.device` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type DeviceStateAlias = Reactily.DeviceState
```

## Definition

```luau
export type DeviceState = {
	hasGamepad: boolean,
	hasKeyboard: boolean,
	hasMouse: boolean,
	hasTouch: boolean,
	isConsole: boolean,
	isDesktop: boolean,
	isMobile: boolean,
	orientation: "Landscape" | "Portrait",
	viewportSize: Vector2,
}
```

## Notes

- Use `Reactily.DeviceState` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
