---
title: "Type: ObjectPool"
sidebar_label: ObjectPool
description: Luau type Reactily.ObjectPool, exported from core.objectPool.
api_types: ObjectPool
---

# `Reactily.ObjectPool`

`ObjectPool` is a public Luau type exported from the `core.objectPool` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ObjectPoolAlias<T> = Reactily.ObjectPool<T>
```

## Definition

```luau
export type ObjectPool<T> = {
	acquire: () -> T,
	clear: () -> (),
	delete: () -> boolean,
	getAvailableCount: () -> number,
	getCreatedCount: () -> number,
	isDeleted: () -> boolean,
	release: (object: T) -> boolean,
}
```

## Notes

- Use `Reactily.ObjectPool` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
