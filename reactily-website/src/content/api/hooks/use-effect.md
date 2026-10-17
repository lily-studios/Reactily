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

## Understanding this API

An effect is for work performed outside rendering, such as connecting a Roblox event, subscribing to a signal, or coordinating an external Instance.

### Practical guidance

Return a cleanup function to disconnect or undo previous work. The dependencies array controls when the effect must be reconsidered; omitting or changing dependencies affects how often it runs.

## Additional usage notes

### When to use it

Use an effect to synchronize a mounted component with subscriptions, time-based work, or external Roblox objects.

### Behavior and ownership

The effect runs as part of Reactily’s managed lifecycle. Return a cleanup callback when creating a subscription or connection.

### Pitfalls to avoid

> **Note:** Avoid starting a new event connection on every render without disconnecting the previous one.
