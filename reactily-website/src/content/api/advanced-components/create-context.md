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
