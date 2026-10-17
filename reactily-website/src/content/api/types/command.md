---
title: "Type: Command"
sidebar_label: Command
description: Luau type Reactily.Command, exported from interface.command.
api_types: Command
---

# `Reactily.Command`

`Command` is a public Luau type exported from the `interface.command` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type CommandAlias = Reactily.Command
```

## Definition

```luau
export type Command = {
	canExecute: (() -> boolean)?,
	execute: (...any) -> (),
}
```

## Notes

- Use `Reactily.Command` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
