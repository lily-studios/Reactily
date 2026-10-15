---
title: "Type: Selector"
sidebar_label: Selector
description: Luau type Reactily.Selector, exported from state.store.
api_types: Selector
---

# `Reactily.Selector`

`Selector` is a public Luau type exported from the `state.store` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type SelectorAlias<T> = Reactily.Selector<T>
```

## Definition

```luau
export type Selector<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (Change: Change<T>) -> ()) -> signalModule.Connection,
}
```

## Notes

- Use `Reactily.Selector` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
