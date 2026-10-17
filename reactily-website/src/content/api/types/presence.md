---
title: "Type: Presence"
sidebar_label: Presence
description: Luau type Reactily.Presence, exported from runtime.presence.
api_types: Presence
---

# `Reactily.Presence`

`Presence` is a public Luau type exported from the `runtime.presence` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type PresenceAlias = Reactily.Presence
```

## Definition

```luau
export type Presence = {
	delete: () -> boolean,
	hide: () -> boolean,
	isDeleted: () -> boolean,
	isVisible: () -> boolean,
	show: () -> boolean,
}
```

## Notes

- Use `Reactily.Presence` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
