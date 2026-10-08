---
title: Reactily.startTransition
sidebar_label: startTransition
sidebar_position: 8
description: API reference for Reactily.startTransition.
---

# `Reactily.startTransition`

Starts low-priority one-shot transition work.

## Signature
```luau
Reactily.startTransition(callback: () -> ()): thread
```
## Usage
```luau
Reactily.startTransition(function()
	updateState()
end)
```
## Works with

Pairs naturally with `useTransition`, `useDeferredValue`, low-priority store updates.
