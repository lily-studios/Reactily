---
title: Reactily.useControllableState
sidebar_label: useControllableState
sidebar_position: 7
description: API reference for Reactily.useControllableState.
---

# `Reactily.useControllableState`

Creates state that can be controlled by props or managed internally.

## Signature
```luau
Reactily.useControllableState<T>(options: ControllableStateOptions<T>): (T, StateSetter<T>)
```
## Usage
```luau
local value, setValue = Reactily.useControllableState({
	Value = props.value,
	DefaultValue = 0,
	OnChanged = props.onChanged,
})
```
## Works with

Pairs naturally with controlled component props, `useEffectEvent`, typed creators.
