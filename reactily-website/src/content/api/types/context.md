---
title: "Type: Context"
sidebar_label: Context
description: Luau type Reactily.Context, exported from state.context.
api_types: Context
---

# `Reactily.Context`

`Context` is a public Luau type exported from the `state.context` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ContextAlias<T> = Reactily.Context<T>
```

## Definition

```luau
export type Context<T> = {
	__reactilyContext: true,
	defaultValue: T,
	id: number,
}
```

## Notes

- Use `Reactily.Context` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
