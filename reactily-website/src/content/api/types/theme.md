---
title: "Type: Theme"
sidebar_label: Theme
description: Luau type Reactily.Theme, exported from interface.theme.
api_types: Theme
---

# `Reactily.Theme`

`Theme` is a public Luau type exported from the `interface.theme` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ThemeAlias<T> = Reactily.Theme<T>
```

## Definition

```luau
export type Theme<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (value: T) -> ()) -> signalModule.Connection,
	update: (updater: (value: T) -> T) -> boolean,
}
```

## Notes

- Use `Reactily.Theme` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
