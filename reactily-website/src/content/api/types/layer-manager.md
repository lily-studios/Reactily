---
title: "Type: LayerManager"
sidebar_label: LayerManager
description: Luau type Reactily.LayerManager, exported from interface.layer.
api_types: LayerManager
---

# `Reactily.LayerManager`

`LayerManager` is a public Luau type exported from the `interface.layer` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type LayerManagerAlias = Reactily.LayerManager
```

## Definition

```luau
export type LayerManager = {
	delete: () -> boolean,
	get: (name: string) -> ScreenGui?,
	getOrCreate: (name: string, definition: LayerDefinition?) -> ScreenGui,
	isDeleted: () -> boolean,
	portal: (name: string, children: { any }, key: string?) -> elementModule.Element,
}
```

## Notes

- Use `Reactily.LayerManager` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
