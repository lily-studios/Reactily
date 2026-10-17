---
title: "Type: VariableVirtualList"
sidebar_label: VariableVirtualList
description: Luau type Reactily.VariableVirtualList, exported from interface.virtualWindow.
api_types: VariableVirtualList
---

# `Reactily.VariableVirtualList`

`VariableVirtualList` is a public Luau type exported from the `interface.virtualWindow` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type VariableVirtualListAlias = Reactily.VariableVirtualList
```

## Definition

```luau
export type VariableVirtualList = {
	delete: () -> boolean,
	getRange: () -> VariableRange,
	isDeleted: () -> boolean,
	setScrollOffset: (scrollOffset: number) -> boolean,
	setSize: (index: number, size: number) -> boolean,
	setSizes: (sizes: { number }) -> boolean,
	setViewportSize: (viewportSize: number) -> boolean,
}
```

## Notes

- Use `Reactily.VariableVirtualList` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
