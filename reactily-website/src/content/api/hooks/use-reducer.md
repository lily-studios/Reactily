---
title: Reactily.useReducer
sidebar_label: useReducer
sidebar_position: 25
description: API reference for Reactily.useReducer.
---

# `Reactily.useReducer`

Provides typed reducer-driven component state and a stable dispatch function.

## Signature
```luau
Reactily.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, ReducerDispatch<A>)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `reducer` | `(stateValue: S, action: A) -> S` | Yes | Pure reducer that receives the current state and an action, then returns the next state. |
| `initialState` | `S` | Yes | State value used for the first render. |

## Returns

`(S, ReducerDispatch<A>)`.

## Usage
```luau
local state, dispatch = Reactily.useReducer(reducer, initialState)
dispatch({type = "increment"})
```

## Understanding this API

Reducer state is useful when several different user actions modify the same model. A reducer centralizes those state transitions in a function rather than distributing the rules across many event handlers.

### Practical guidance

Dispatch actions that describe what happened; keep the reducer free of unrelated Roblox side effects so updates remain predictable.

## Additional usage notes

### When to use it

Use this hook when the component needs provides typed reducer-driven component state and a stable dispatch function.

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
