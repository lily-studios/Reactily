---
title: "Type: FragmentInstance"
sidebar_label: FragmentInstance
description: Luau type Reactily.FragmentInstance, exported from runtime.fragmentRef.
api_types: FragmentInstance
---

# `Reactily.FragmentInstance`

`FragmentInstance` is a public Luau type exported from the `runtime.fragmentRef` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type FragmentInstanceAlias = Reactily.FragmentInstance
```

## Definition

```luau
export type FragmentInstance = {
	blur: () -> (),
	connectEvent: (eventName: string, callback: (...any) -> ()) -> () -> (),
	delete: () -> boolean,
	focus: () -> boolean,
	focusLast: () -> boolean,
	getBounds: () -> (Vector2?, Vector2?),
	getInstances: () -> { Instance },
	isDeleted: () -> boolean,
	observeBounds: (callback: () -> ()) -> () -> (),
	refresh: () -> (),
	scrollIntoView: (alignToTop: boolean?) -> boolean,
}
```

## Notes

- Use `Reactily.FragmentInstance` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
