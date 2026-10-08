---
title: Reactily.useActionState
sidebar_label: useActionState
sidebar_position: 40
description: Tracks state driven by an action and reports whether the action is running in a Reactily transition.
---

# `Reactily.useActionState`

Tracks state driven by an action and reports whether the action is running in a Reactily transition.

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

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
