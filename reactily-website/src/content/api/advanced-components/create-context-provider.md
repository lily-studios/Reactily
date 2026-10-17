---
title: Reactily.createContextProvider
sidebar_label: createContextProvider
sidebar_position: 10
description: API reference for Reactily.createContextProvider.
---

# `Reactily.createContextProvider`

Creates a provider element for a Reactily context.

## Signature
```luau
Reactily.createContextProvider<T>(contextValue: Context<T>, value: T, children: {any}, key: string?): Element
```
## Usage
```luau
local provider = Reactily.createContextProvider(
	Context,
	value,
	{
		child,
	}
)
```
## Works with

Pairs naturally with `createContext`, `useContext`, component trees.

## Understanding this API

Advanced component utilities change how Reactily constructs, loads, wraps, or reuses part of the virtual tree. Their behavior affects rendering and component boundaries, not the underlying Roblox Instance class directly.

### Practical guidance

Choose these only when you need their particular behavior; ordinary user interfaces can be built with typed creators and `createComponent`. Understand the component lifecycle and return type before adding wrappers.

## Additional usage notes

### When to use it

Use this creator when you need the ContextProvider capability described above, and keep its result under a clear owner.

### Behavior and ownership

Component helpers affect how an element is wrapped, loaded, or constructed inside the virtual tree.

### Pitfalls to avoid

> **Note:** A component wrapper does not become a Roblox Instance until rendered by a root.
