---
title: Reactily.createProfiler
description: Creates a Profiler element for observing a child subtree.
---

# `Reactily.createProfiler`

Creates a Profiler element for observing a child subtree. This export is included in Reactily v2.2.0 (API v1).

## Signature

```luau
Reactily.createProfiler(id: string, child: Element, onRender: ((...any) -> ())?, key: string?): Element
```

## Usage

```luau
local measured = Reactily.createProfiler("Inventory", inventoryElement, onRender)
```

Use this hook or constructor only in a valid Reactily component/render context, as applicable.

## Understanding this API

The Profiler component marks a subtree for reporting render timing and related diagnostic information.

### Practical guidance

Use it to investigate specific expensive trees, then remove unnecessary instrumentation once the bottleneck is understood.

## Additional usage notes

### When to use it

Use this specialized component to observe render activity for a subtree while profiling.

### Behavior and ownership

The profiler provides measurements about component rendering, rather than game frame-rate or network timing.

### Pitfalls to avoid

> **Note:** Only interpret recorded durations as the profiling system defines them; they are not total frame time.
