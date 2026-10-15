---
title: "Type: Binding"
sidebar_label: Binding
description: Luau type Reactily.Binding, exported from runtime.binding.
api_types: Binding
---

# `Reactily.Binding`

`Binding` is a public Luau type exported from the `runtime.binding` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type BindingAlias<T> = Reactily.Binding<T>
```

## Definition

```luau
export type Binding<T> = {
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	set: (value: T) -> boolean,
	subscribe: (callback: (change: BindingChange<T>) -> ()) -> signalModule.Connection,
}
```

## Notes

- Use `Reactily.Binding` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
