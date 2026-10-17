---
title: "Type: Computed"
sidebar_label: Computed
description: Luau type Reactily.Computed, exported from state.atom.
api_types: Computed
---

# `Reactily.Computed`

`Computed` is a public Luau type exported from the `state.atom` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ComputedAlias<T> = Reactily.Computed<T>
```

## Definition

```luau
export type Computed<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	subscribe: (callback: (change: AtomChange<T>) -> ()) -> signalModule.Connection,
}
```

## Notes

- Use `Reactily.Computed` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
