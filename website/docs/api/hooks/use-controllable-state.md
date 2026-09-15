---
title: Reactily.useControllableState
sidebar_label: useControllableState
sidebar_position: 7
description: API reference for Reactily.useControllableState.
---

# `Reactily.useControllableState`

Creates state that can be controlled by props or managed internally.

## Signature
```typescript
Reactily.useControllableState<T>(options: controllableStateOptions<T>): (T, stateSetter<T>)
```
## Usage
```typescript
local value, setValue = Reactily.useControllableState({
	value = props.value,
	defaultValue = 0,
	onChanged = props.onChanged,
})
```
## Works with

Pairs naturally with controlled component props, `useEvent`, typed creators.
