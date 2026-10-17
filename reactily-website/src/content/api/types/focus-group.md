---
title: "Type: FocusGroup"
sidebar_label: FocusGroup
description: Luau type Reactily.FocusGroup, exported from interface.focus.
api_types: FocusGroup
---

# `Reactily.FocusGroup`

`FocusGroup` is a public Luau type exported from the `interface.focus` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type FocusGroupAlias = Reactily.FocusGroup
```

## Definition

```luau
export type FocusGroup = {
	add: (object: GuiObject) -> boolean,
	clear: () -> (),
	delete: () -> boolean,
	focusFirst: () -> boolean,
	focusLast: () -> boolean,
	focusNext: () -> boolean,
	focusPrevious: () -> boolean,
	getCurrent: () -> GuiObject?,
	getItems: () -> { GuiObject },
	isDeleted: () -> boolean,
	remove: (object: GuiObject) -> boolean,
	setWrapAround: (enabled: boolean) -> boolean,
}
```

## Notes

- Use `Reactily.FocusGroup` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
