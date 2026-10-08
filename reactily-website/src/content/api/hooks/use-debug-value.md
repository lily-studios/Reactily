---
title: Reactily.useDebugValue
description: Associates a formatted debug value with the currently rendering component.
---

# `Reactily.useDebugValue`

Associates a formatted debug value with the currently rendering component. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useDebugValue<T>(value: T, formatter: ((value: T) -> any)?)
```

## Usage

```luau
Reactily.useDebugValue(value, tostring)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
