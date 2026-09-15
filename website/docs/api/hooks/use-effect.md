---
title: Reactily.useEffect
sidebar_label: useEffect
sidebar_position: 11
description: API reference for Reactily.useEffect.
---

# `Reactily.useEffect`

Runs an effect after a completed component render and supports cleanup.

## Signature
```typescript
Reactily.useEffect(callback: () -> (() -> ())?, dependencies: {any}?)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `callback` | `() -> (() -> ())?, dependencies: {any}?` | No | Function Reactily calls for the operation, subscription, effect, batch, scheduled task, or event. |

## Returns

No value.

## Usage
```typescript
Reactily.useEffect(function()
	local connection = signal:Connect(onChanged)

	return function()
		connection:Disconnect()
	end
end, {signal})
```
