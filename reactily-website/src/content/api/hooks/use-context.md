---
title: Reactily.useContext
sidebar_label: useContext
sidebar_position: 6
description: API reference for Reactily.useContext.
---

# `Reactily.useContext`

Reads the current value from a Reactily context.

## Signature
```luau
Reactily.useContext<T>(contextValue: Context<T>): T
```
## Usage
```luau
local Value = Reactily.useContext(Context)
```
## Works with

Pairs naturally with `createContext`, `createContextProvider`, `memo`.

## Understanding this API

Context makes a shared value available to descendants without manually passing it through every intermediate component.

### Practical guidance

A matching provider must exist above the consumer when the application requires a provided value; use context for shared dependencies, not for high-frequency per-object updates.

## Additional usage notes

### When to use it

Use `useContext` to read a value supplied by the nearest matching context provider.

### Behavior and ownership

The read is associated with a component’s render; the context must be the one created by `createContext`.

### Pitfalls to avoid

> **Note:** Creating a new context object during each render prevents consumers from sharing the intended provider.
