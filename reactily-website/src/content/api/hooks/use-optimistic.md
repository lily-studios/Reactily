---
title: Reactily.useOptimistic
sidebar_label: useOptimistic
sidebar_position: 47
description: Provides optimistic state derived from a base value and reducer.
---

# `Reactily.useOptimistic`

Provides optimistic state derived from a base value and reducer.

## Signature

```luau
Reactily.useOptimistic<T, A>(value: T, reducer: ((current: T, action: A) -> T)?): (T, (action: A) -> ())
```

## Usage

```luau
local optimistic, dispatch = Reactily.useOptimistic(value, function(current, amount)
	return current + amount
end)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
