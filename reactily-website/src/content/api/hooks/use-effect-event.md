---
title: Reactily.useEffectEvent
description: Creates an Effect Event that reads the latest committed values without resubscribing the effect.
---

# `Reactily.useEffectEvent`

Creates an Effect Event that reads the latest committed values without resubscribing the effect. This export is included in Reactily v2.1.0 (API v1).

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

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
