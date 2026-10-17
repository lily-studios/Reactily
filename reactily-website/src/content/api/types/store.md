---
title: "Type: Store"
sidebar_label: Store
description: Luau type Reactily.Store, exported from state.store.
api_types: Store
---

# `Reactily.Store`

`Store` is a public Luau type exported from the `state.store` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type StoreAlias<T> = Reactily.Store<T>
```

## Definition

```luau
export type Store<T> = {
	batch: (callback: () -> ()) -> (),
	delete: () -> boolean,
	get: () -> T,
	isDeleted: () -> boolean,
	reset: () -> boolean,
	select: <R>((state: T) -> R) -> Selector<R>,
	set: (state: T) -> boolean,
	subscribe: (callback: (Change: Change<T>) -> ()) -> signalModule.Connection,
	transaction: (callback: () -> ()) -> (),
	update: (updater: (state: T) -> T) -> boolean,
	use: (middlewareValue: Middleware<T>) -> () -> (),
}
```

## Notes

- Use `Reactily.Store` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
