---
title: Reactily.useEffect
sidebar_label: useEffect
sidebar_position: 11
description: API reference for Reactily.useEffect.
---

# `Reactily.useEffect`

Runs an effect after a completed component render and supports cleanup.

## Signature
```luau
Reactily.useEffect(callback: () -> (() -> ())?, dependencies: {any}?)
```
## Parameters

| Parameter | Type | Required | Description |
| --- | --- | :---: | --- |
| `callback` | `() -> (() -> ())?` | Yes | Runs after the component renders; may return a cleanup callback. |
| `dependencies` | `{any}?` | No | Re-runs the effect when a dependency changes. |

## Returns

No value.

## Usage
```luau
Reactily.useEffect(function()
	local Connection = Signal:Connect(onChanged)

	return function()
		Connection:Disconnect()
	end
end, {Signal})
```
