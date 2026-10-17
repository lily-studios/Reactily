---
title: "Type: Resource"
sidebar_label: Resource
description: Luau type Reactily.Resource, exported from runtime.resource.
api_types: Resource
---

# `Reactily.Resource`

`Resource` is a public Luau type exported from the `runtime.resource` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ResourceAlias<T> = Reactily.Resource<T>
```

## Definition

```luau
export type Resource<T> = {
	delete: () -> boolean,
	get: () -> T?,
	getError: () -> any,
	getStatus: () -> ResourceStatus,
	isDeleted: () -> boolean,
	preload: () -> (),
	read: () -> T,
	refresh: () -> (),
	subscribe: (callback: () -> ()) -> signalModule.Connection,
}
```

## Notes

- Use `Reactily.Resource` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
