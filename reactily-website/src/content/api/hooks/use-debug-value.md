---
title: Reactily.useDebugValue
sidebar_label: useDebugValue
sidebar_position: 42
description: Associates a formatted debug value with the currently rendering component.
---

# `Reactily.useDebugValue`

Associates a formatted debug value with the currently rendering component.

## Signature

```luau
Reactily.useDebugValue<T>(value: T, formatter: ((value: T) -> any)?)
```

## Usage

```luau
Reactily.useDebugValue(value, tostring)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
