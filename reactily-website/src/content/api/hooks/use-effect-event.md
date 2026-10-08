---
title: Reactily.useEffectEvent
sidebar_label: useEffectEvent
sidebar_position: 44
description: Creates an Effect Event that reads the latest committed values without resubscribing the effect.
---

# `Reactily.useEffectEvent`

Creates an Effect Event that reads the latest committed values without resubscribing the effect.

## Signature

```luau
Reactily.useEffectEvent<T>(callback: T): T
```

## Usage

```luau
local onConnected = Reactily.useEffectEvent(function()
	print(currentTheme)
end)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
