---
title: Reactily.createContext
sidebar_label: createContext
sidebar_position: 2
description: API reference for Reactily.createContext.
---

# `Reactily.createContext`

Creates a typed Reactily context with a fallback value.

## Signature
```luau
Reactily.createContext<T>(defaultValue: T): Context<T>
```
## Usage
```luau
local Context = Reactily.createContext({
	Enabled = true,
})
```
## Works with

Pairs naturally with `createContextProvider`, `useContext`, `memo`.

## Understanding this API

Advanced component utilities change how Reactily constructs, loads, wraps, or reuses part of the virtual tree. Their behavior affects rendering and component boundaries, not the underlying Roblox Instance class directly.

### Practical guidance

Choose these only when you need their particular behavior; ordinary user interfaces can be built with typed creators and `createComponent`. Understand the component lifecycle and return type before adding wrappers.

## Additional usage notes

### When to use it

Use context when a subtree needs the same configuration or state without threading the value through every intermediate component.

### Behavior and ownership

`createContext` defines the context identity and a fallback value; a provider supplies a value to consumers.

### Pitfalls to avoid

> **Note:** Define contexts once at module scope, not on every component render.
