---
title: Reactily.createViewTransition
description: Creates a ViewTransition element with optional transition callbacks and configuration.
---

# `Reactily.createViewTransition`

Creates a ViewTransition element with optional transition callbacks and configuration. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.createViewTransition(child: Element, config: {[string]: any}?, onEnter: ((...any) -> ())?, onExit: ((...any) -> ())?, onUpdate: ((...any) -> ())?, key: string?): Element
```

## Usage

```luau
local transition = Reactily.createViewTransition(panel, { Duration = 0.2 })
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
