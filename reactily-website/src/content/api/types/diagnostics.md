---
title: "Type: Diagnostics"
sidebar_label: Diagnostics
description: Luau type Reactily.Diagnostics, exported from diagnostics.diagnostics.
api_types: Diagnostics
---

# `Reactily.Diagnostics`

`Diagnostics` is a public Luau type exported from the `diagnostics.diagnostics` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type DiagnosticsAlias = Reactily.Diagnostics
```

## Definition

```luau
export type Diagnostics = {
	delete: () -> boolean,
	get: (name: string) -> number,
	increment: (name: string, amount: number?) -> number,
	isDeleted: () -> boolean,
	reset: (name: string) -> boolean,
	resetAll: () -> (),
	snapshot: () -> { [string]: number },
}
```

## Notes

- Use `Reactily.Diagnostics` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
