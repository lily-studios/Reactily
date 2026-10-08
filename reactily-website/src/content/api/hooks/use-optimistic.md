---
title: Reactily.useOptimistic
description: Provides optimistic state derived from a base value and reducer.
---

# `Reactily.useOptimistic`

Provides optimistic state derived from a base value and reducer. This export is included in Reactily v2.1.0 (API v1).

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

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
