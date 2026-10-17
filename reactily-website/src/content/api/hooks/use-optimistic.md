---
title: Reactily.useOptimistic
description: Provides optimistic state derived from a base value and reducer.
---

# `Reactily.useOptimistic`

Provides optimistic state derived from a base value and reducer. This export is included in Reactily v2.2.0 (API v1).

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

## Understanding this API

Optimistic state lets the UI show a proposed update before the underlying operation has finished.

### Practical guidance

Decide how to handle rejection or failure so the optimistic value does not become a permanent mismatch with the real data.

## Additional usage notes

### When to use it

Use this hook when the component needs provides optimistic state derived from a base value and reducer. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
