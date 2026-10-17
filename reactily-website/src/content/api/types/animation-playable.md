---
title: "Type: AnimationPlayable"
sidebar_label: AnimationPlayable
description: Luau type Reactily.AnimationPlayable, exported from runtime.animationGroup.
api_types: AnimationPlayable
---

# `Reactily.AnimationPlayable`

`AnimationPlayable` is a public Luau type exported from the `runtime.animationGroup` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type AnimationPlayableAlias = Reactily.AnimationPlayable
```

## Definition

```luau
export type AnimationPlayable = Playable
```

## Notes

- Use `Reactily.AnimationPlayable` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
