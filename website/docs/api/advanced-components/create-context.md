---
title: Reactily.createContext
sidebar_label: createContext
sidebar_position: 2
description: API reference for Reactily.createContext.
---

# `Reactily.createContext`

Creates a typed Reactily context with a fallback value.

## Signature
```typescript
Reactily.createContext<T>(defaultValue: T): context<T>
```
## Usage
```typescript
local context = Reactily.createContext({
	enabled = true,
})
```
## Works with

Pairs naturally with `createContextProvider`, `useContext`, `memo`.
