---
title: Reactily.useMeasure
sidebar_label: useMeasure
sidebar_position: 46
description: Subscribes to the measured absolute bounds of a GuiObject.
---

# `Reactily.useMeasure`

Subscribes to the measured absolute bounds of a GuiObject.

## Signature

```luau
Reactily.useMeasure(object: GuiObject): { AbsolutePosition: Vector2, AbsoluteSize: Vector2 }
```

## Usage

```luau
local bounds = Reactily.useMeasure(frame)
print(bounds.AbsoluteSize)
```

## Notes

This API is exported by the current unreleased Reactily 1.4.0 development runtime and is safe to use from a function component where the hook rules allow it.
