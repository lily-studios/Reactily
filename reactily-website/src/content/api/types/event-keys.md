---
title: "Type: EventKeys"
sidebar_label: EventKeys
description: Luau type Reactily.EventKeys, exported from runtime.hostConfig.
api_types: EventKeys
---

# `Reactily.EventKeys`

`EventKeys` is a public Luau type exported from the `runtime.hostConfig` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type EventKeysAlias = Reactily.EventKeys
```

## Definition

```luau
export type EventKeys = {
	Activated: "onActivated",
	AncestryChanged: "onAncestryChanged",
	Changed: "onChanged",
	Focused: "onFocused",
	FocusLost: "onFocusLost",
	InputBegan: "onInputBegan",
	InputChanged: "onInputChanged",
	InputEnded: "onInputEnded",
	MouseButton1Click: "onMouseButton1Click",
	MouseButton1Down: "onMouseButton1Down",
	MouseButton1Up: "onMouseButton1Up",
	MouseButton2Click: "onMouseButton2Click",
	MouseButton2Down: "onMouseButton2Down",
	MouseButton2Up: "onMouseButton2Up",
	MouseEnter: "onMouseEnter",
	MouseLeave: "onMouseLeave",
	SelectionGained: "onSelectionGained",
	SelectionLost: "onSelectionLost",
}
```

## Notes

- Use `Reactily.EventKeys` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
