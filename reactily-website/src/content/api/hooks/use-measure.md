---
title: Reactily.useMeasure
description: Subscribes to the measured absolute bounds of a GuiObject.
---

# `Reactily.useMeasure`

Subscribes to the measured absolute bounds of a GuiObject. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.useMeasure(object: GuiObject): { AbsolutePosition: Vector2, AbsoluteSize: Vector2 }
```

## Usage

```luau
local bounds = Reactily.useMeasure(frame)
print(bounds.AbsoluteSize)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
