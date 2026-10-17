---
title: "Type: PropMap"
sidebar_label: PropMap
description: Luau type Reactily.PropMap, exported from interface.props.
api_types: PropMap
---

# `Reactily.PropMap`

`PropMap` is a public Luau type exported from the `interface.props` source module. Use it for strict annotations and autocomplete; it is not a runtime table or function.

## Public type

```luau
type PropMapAlias = Reactily.PropMap
```

## Definition

```luau
export type PropMap = { [any]: any }
```

## Notes

- Use `Reactily.PropMap` in type positions, not as a runtime value.
- Reactily custom fields follow camelCase; native Roblox instance properties retain PascalCase.
- Generic parameters, where present, should be specialized for your own data types.

## When to use this type

Use this exported type in strict Luau files to document expected values and receive useful editor diagnostics.

## Notes and common mistakes

- Types are erased at runtime. Do not call them as functions or attempt to `require()` them as ModuleScripts.
- Check optional fields and generic type parameters in the definition before assigning a concrete value.
