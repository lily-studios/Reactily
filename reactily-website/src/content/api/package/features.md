---
title: Reactily.features
sidebar_label: features
sidebar_position: 4
description: Read-only capability flags exported by the Reactily runtime.
---

# `Reactily.features`

A frozen capability map for feature detection.

```luau
if Reactily.features["optimistic-state"] then
	-- safe to use Reactily.useOptimistic
end
```

Reactily v2.2.0 (API v1) exposes these capability flags: `action-state`, `activity`, `concurrent-priorities`, `effect-events`, `fragment-refs`, `host-metadata`, `insertion-effects`, `optimistic-state`, `profiler-Component`, `strict-mode-checks`, `suspense`, `sync-external-Store`, `transitions`, `use-api`, `view-transitions`, `virtual-grid`, `virtual-list`, and `virtual-window`. Check a flag before depending on an optional capability.

## Understanding this API

Package metadata describes the installed Reactily build and its supported feature surface. Use it to understand compatibility rather than to render UI.

### Practical guidance

The published package version and API compatibility version answer different questions: a package can receive new features without changing the API compatibility identifier.

## Additional usage notes

### When to use it

Use this helper when a frozen capability map for feature detection.

### Behavior and ownership

Package helpers expose metadata, compatibility, or convenience entrypoints.

### Pitfalls to avoid

> **Note:** Check the runtime package version and public API version separately; they represent different things.
