---
title: Reactily.createProfiler
description: Creates a Profiler element for observing a child subtree.
---

# `Reactily.createProfiler`

Creates a Profiler element for observing a child subtree. This export is included in Reactily v2.1.0 (API v1).

## Signature

```luau
Reactily.createProfiler(id: string, child: Element, onRender: ((...any) -> ())?, key: string?): Element
```

## Usage

```luau
local measured = Reactily.createProfiler("Inventory", inventoryElement, onRender)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.
