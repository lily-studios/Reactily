---
title: Reactily.useUnmount
sidebar_label: useUnmount
sidebar_position: 33
description: API reference for Reactily.useUnmount.
---

# `Reactily.useUnmount`

Registers cleanup that runs only when the component unmounts.

## Signature
```luau
Reactily.useUnmount(callback: () -> ()): ()
```
## Usage
```luau
Reactily.useUnmount(function()
	print("Unmounted")
end)
```
## Works with

Pairs naturally with `useMount`, `useOwned`, effect cleanup.
