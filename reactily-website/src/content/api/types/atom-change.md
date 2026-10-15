---
title: "Type: AtomChange"
sidebar_label: AtomChange
description: Luau type Reactily.AtomChange, exported from state.atom.
api_types: AtomChange
---

# `Reactily.AtomChange`

`AtomChange` is a public Luau type exported from the `state.atom` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type AtomChangeAlias<T> = Reactily.AtomChange<T>
```

## Definition

```luau
export type AtomChange<T> = {
	current: T,
	previous: T,
}
```

## Notes

- Use `Reactily.AtomChange` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
