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
Reactily.createContextProvider<T>(contextValue: context<T>, value: T, children: {any}, key: string?): element
```
## Usage
```luau
local provider = Reactily.createContextProvider(
	context,
	value,
	{
		child,
	}
)
```
## Works with

Pairs naturally with `createContext`, `useContext`, component trees.
