---
title: Reactily.createViewTransition
description: Creates a ViewTransition element with optional transition callbacks and configuration.
---

# `Reactily.createViewTransition`

Creates a ViewTransition element with optional transition callbacks and configuration. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.createViewTransition(child: Element, config: {[string]: any}?, onEnter: ((...any) -> ())?, onExit: ((...any) -> ())?, onUpdate: ((...any) -> ())?, key: string?): Element
```

## Usage

```luau
local transition = Reactily.createViewTransition(panel, { Duration = 0.2 })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

ViewTransition coordinates callbacks and visual state changes between different mounted views.

### Practical guidance

Provide reliable enter/update/exit behavior and clean up any work initiated by the transition when the related UI is removed.

## Additional usage notes

### When to use it

Use view transitions when changing between UI states and coordinating their enter/update/exit phases.

### Behavior and ownership

The specialized component coordinates callbacks around a change in rendered view.

### Pitfalls to avoid

> **Note:** Keep transitions safe if the component unmounts while a transition is pending.
