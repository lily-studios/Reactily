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
Reactily.useContext<T>(contextValue: context<T>): T
```
## Usage
```luau
local value = Reactily.useContext(context)
```
## Works with

Pairs naturally with `createContext`, `createContextProvider`, `memo`.
