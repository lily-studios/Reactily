---
title: "Type: Signal"
sidebar_label: Signal
description: Luau type Reactily.Signal, exported from core.signal.
api_types: Signal
---

# `Reactily.Signal`

`Signal` is a public Luau type exported from the `core.signal` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type SignalAlias<T> = Reactily.Signal<T>
```

## Definition

```luau
export type Signal<T> = {
	connect: (callback: (value: T) -> ()) -> Connection,
	delete: () -> boolean,
	fire: (value: T) -> (),
	getListenerCount: () -> number,
	isDeleted: () -> boolean,
	once: (callback: (value: T) -> ()) -> Connection,
}
```

## Notes

- Use `Reactily.Signal` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
