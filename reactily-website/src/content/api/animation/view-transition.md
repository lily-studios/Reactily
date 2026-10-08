---
title: Reactily.ViewTransition
description: Compatibility component for configuring enter, exit, and update transitions.
---

# `Reactily.ViewTransition`

Compatibility component for configuring enter, exit, and update transitions. This export is present in the Reactily v2.1.0 package (API v1).

## Signature

```luau
Reactily.ViewTransition(props: { Children: Element, Config: {[string]: any}?, Key: string?, OnEnter: ((...any) -> ())?, OnExit: ((...any) -> ())?, OnUpdate: ((...any) -> ())? }): Element
```

## Usage

```luau
local transition = Reactily.ViewTransition({ Children = child, Config = { Duration = 0.2 } })
```

See the related API pages for parameter details and supported behavior. Check the v2.1.0 release source when integrating APIs whose callback or option types are important to your project.
