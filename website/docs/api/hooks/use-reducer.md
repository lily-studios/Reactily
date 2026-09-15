---
title: Reactily.useReducer
sidebar_label: useReducer
sidebar_position: 25
description: API reference for Reactily.useReducer.
---

# `Reactily.useReducer`

Provides typed reducer-driven component state and a stable dispatch function.

## Signature
```typescript
Reactily.useReducer<S, A>(
	reducer: (stateValue: S, action: A) -> S,
	initialState: S
): (S, reducerDispatch<A>)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `reducer` | `(stateValue: S, action: A) -> S,
	initialState: S` | Yes | Pure reducer function that resolves the next state from the current state and action. |

## Returns

`(S, reducerDispatch<A>)`.

## Usage
```typescript
local state, dispatch = Reactily.useReducer(reducer, initialState)
dispatch({type = "increment"})
```
