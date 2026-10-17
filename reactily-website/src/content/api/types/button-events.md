---
title: "Type: ButtonEvents"
sidebar_label: ButtonEvents
description: Luau type Reactily.ButtonEvents, exported from virtual.element.
api_types: ButtonEvents
---

# `Reactily.ButtonEvents`

`ButtonEvents` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ButtonEventsAlias = Reactily.ButtonEvents
```

## Definition

```luau
export type ButtonEvents = {
	onActivated: ((input: InputObject, clickCount: number) -> ())?,
	onMouseButton1Click: (() -> ())?,
	onMouseButton1Down: ((x: number, y: number) -> ())?,
	onMouseButton1Up: ((x: number, y: number) -> ())?,
	onMouseButton2Click: (() -> ())?,
	onMouseButton2Down: ((x: number, y: number) -> ())?,
	onMouseButton2Up: ((x: number, y: number) -> ())?,
}
```

## Notes

- Use `Reactily.ButtonEvents` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
