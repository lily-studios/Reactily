---
title: "Type: GridRange"
sidebar_label: GridRange
description: Luau type Reactily.GridRange, exported from interface.virtualGrid.
api_types: GridRange
---

# `Reactily.GridRange`

`GridRange` is a public Luau type exported from the `interface.virtualGrid` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type GridRangeAlias = Reactily.GridRange
```

## Definition

```luau
export type GridRange = {
	columnCount: number,
	firstIndex: number,
	firstRow: number,
	lastIndex: number,
	lastRow: number,
	offsetY: number,
	rowCount: number,
	totalHeight: number,
}
```

## Notes

- Use `Reactily.GridRange` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
