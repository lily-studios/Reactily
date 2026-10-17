---
title: Reactily.useActionState
description: Tracks state driven by an action and reports whether the action is running in a Reactily transition.
---

# `Reactily.useActionState`

Tracks state driven by an action and reports whether the action is running in a Reactily transition. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.useActionState<S, P>(action: (state: S, payload: P) -> S, initialState: S): (S, (payload: P) -> (), boolean)
```

## Usage

```luau
local state, dispatch, pending = Reactily.useActionState(function(current, amount)
	return current + amount
end, 0)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

This hook coordinates state associated with an action, so a component can track action-related updates through the normal rendering lifecycle.

### Practical guidance

Keep action callbacks focused on the state transition they describe and handle asynchronous failures in the surrounding workflow.

## Additional usage notes

### When to use it

Use this hook when the component needs tracks state driven by an action and reports whether the action is running in a Reactily transition. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
