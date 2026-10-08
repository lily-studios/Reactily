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

Reactily v2.1.0 (API v1) exposes these capability flags: `action-state`, `activity`, `concurrent-priorities`, `effect-events`, `fragment-refs`, `host-metadata`, `insertion-effects`, `optimistic-state`, `profiler-Component`, `strict-mode-checks`, `suspense`, `sync-external-Store`, `transitions`, `use-api`, `view-transitions`, `virtual-grid`, `virtual-list`, and `virtual-window`. Check a flag before depending on an optional capability.
