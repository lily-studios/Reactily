---
title: Reactily.useMeasure
description: Subscribes to the measured absolute bounds of a GuiObject.
---

# `Reactily.useMeasure`

Subscribes to the measured absolute bounds of a GuiObject. This export is included in Reactily v2.2.0 (API v1).

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

## Understanding this API

Measurements make it possible to react to a GUI element’s actual bounds rather than guessing them from its requested `Size`.

### Practical guidance

Use the observed layout value after mounting, and avoid causing a feedback loop by unconditionally writing a size that changes the measured size again.

## Additional usage notes

### When to use it

Use this hook when the component needs subscribes to the measured absolute bounds of a GuiObject. This export is included in Reactily v2.2.0 (API v1).

### Behavior and ownership

This hook participates in component lifecycle and must be invoked in consistent order during rendering.

### Pitfalls to avoid

> **Note:** Calling this hook conditionally or from ordinary utility code can break hook ordering. Use it only in supported render contexts.
