---
title: "Type: Element"
sidebar_label: Element
description: Luau type Reactily.Element, exported from virtual.element.
api_types: Element
---

# `Reactily.Element`

`Element` is a public Luau type exported from the `virtual.element` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type ElementAlias = Reactily.Element
```

## Definition

```luau
export type Element =
	{
		children: { Element },
		className: string,
		key: string?,
		kind: "host",
		props: GenericProps,
	}
	| {
		children: { Element },
		component: (props: GenericProps) -> Element?,
		key: string?,
		kind: "component",
		props: GenericProps,
	}
	| {
		children: { Element },
		key: string?,
		kind: "fragment",
		props: GenericProps,
		refTarget: FragmentRefTarget?,
	}
	| {
		children: { Element },
		key: string?,
		kind: "portal",
		props: GenericProps,
		target: Instance,
	}
	| {
		children: { Element },
		contextValue: any,
		key: string?,
		kind: "provider",
		props: GenericProps,
		providedValue: any,
	}
	| {
		children: { Element },
		fallback: Element | ((failure: any) -> Element),
		key: string?,
		kind: "errorBoundary",
		onError: ((failure: any) -> ())?,
		props: GenericProps,
	}
	| {
		children: { Element },
		fallback: Element,
		key: string?,
		kind: "suspense",
		props: GenericProps,
	}
	| {
		children: { Element },
		key: string?,
		kind: "activity",
		mode: ActivityMode,
		props: GenericProps,
	}
	| {
		children: { Element },
		id: string,
```

## Notes

- Use `Reactily.Element` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

This type represents a Reactily runtime contract. Use it to annotate values returned from the matching factory or to type function parameters.

## Notes and common mistakes

- A type annotation does not create or destroy a runtime object. Manage lifetime through the corresponding instance methods or its owning component/root.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
