---
title: "Type: Measure"
sidebar_label: Measure
description: Luau type Reactily.Measure, exported from interface.measure.
api_types: Measure
---

# `Reactily.Measure`

`Measure` is a public Luau type exported from the `interface.measure` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type MeasureAlias = Reactily.Measure
```

## Definition

```luau
export type Measure = {
	delete: () -> boolean,
	get: () -> Bounds,
	isDeleted: () -> boolean,
	subscribe: (callback: (value: Bounds) -> ()) -> signalModule.Connection,
}
```

## Notes

- Use `Reactily.Measure` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
