---
title: "Type: AttributeValue"
sidebar_label: AttributeValue
description: Luau type Reactily.AttributeValue, exported from virtual.element.
api_types: AttributeValue
---

# `Reactily.AttributeValue`

`AttributeValue` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type AttributeValueAlias = Reactily.AttributeValue
```

## Definition

```luau
export type AttributeValue =
	boolean
	| BrickColor
	| CFrame
	| Color3
	| ColorSequence
	| NumberRange
	| NumberSequence
	| number
	| Rect
	| string
	| UDim
	| UDim2
	| Vector2
	| Vector3
```

## Notes

- Use `Reactily.AttributeValue` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
