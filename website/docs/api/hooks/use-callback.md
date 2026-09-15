---
title: Reactily.useCallback
sidebar_label: useCallback
sidebar_position: 5
description: API reference for Reactily.useCallback.
---

# `Reactily.useCallback`

Memoizes a callback/value by dependency array.

## Signature
```typescript
Reactily.useCallback<T>(callback: T, dependencies: {any}?): T
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `callback` | `T` | Yes | Function Reactily calls for the operation, subscription, effect, batch, scheduled task, or event. |
| `dependencies` | `{any}?` | No | Dependency array used to decide whether the memo, callback, or effect should update. `nil` means it is treated as changed every render. |

## Returns

`T`.

## Usage
```typescript
local onClick = Reactily.useCallback(function()
	print(selection)
end, {selection})
```
