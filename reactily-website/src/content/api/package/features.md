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

The unreleased Reactily 1.4.0 development runtime exposes flags for action state, Effect Events, optimistic state, external-store synchronization, Suspense, transitions, virtualization, and host metadata. DOM-only concepts such as browser View Transitions are explicitly reported as unsupported.
