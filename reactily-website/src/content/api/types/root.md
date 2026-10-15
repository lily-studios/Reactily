---
title: "Type: Root"
sidebar_label: Root
description: Luau type Reactily.Root, exported from runtime.root.
api_types: Root
---

# `Reactily.Root`

`Root` is a public Luau type exported from the `runtime.root` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type RootAlias = Reactily.Root
```

## Definition

```luau
export type Root = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	flush: () -> (),
	getElement: () -> elementModule.Element?,
	getParent: () -> Instance,
	inspect: () -> reconciler.NodeSnapshot?,
	isDeleted: () -> boolean,
	isSuspended: () -> boolean,
	render: (elementValue: elementModule.Element?) -> (),
	resume: () -> boolean,
	suspend: () -> boolean,
}
```

## Notes

- Use `Reactily.Root` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
