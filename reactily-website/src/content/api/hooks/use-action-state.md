---
title: Reactily.useActionState
description: Tracks state driven by an action and reports whether the action is running in a Reactily transition.
---

# `Reactily.useActionState`

Tracks state driven by an action and reports whether the action is running in a Reactily transition. This export is included in Reactily v2.1.0 (API v1).

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
